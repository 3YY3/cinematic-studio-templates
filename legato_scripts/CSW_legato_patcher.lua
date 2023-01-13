--[[
Cinematic Studio Woodwinds (CSW) Legato Patcher
CSW_legato_patcher.lua
Copyright © 2023 3YY3, MIT License
Not affiliated with Cinematic Studio Series in any way.
To be used with 3YY3 Cinematic Studio Series templates.
]]--

exp_legato_slow = 160 -- 220 ms minus 60 ms already taken on the track to compensate short notes
exp_legato_medium = 70 -- 130 ms minus 60 ms already taken on the track to compensate short notes
exp_legato_fast = 30 -- 90 ms minus 60 ms already taken on the track to compensate short notes
ll_legato_medium = 30 -- 90 ms minus 60 ms already taken on the track to compensate short notes
ll_legato_fast = 10 -- 70 ms minus 60 ms already taken on the track to compensate short notes

function takeError()
  reaper.ShowMessageBox("Please, open some MIDI item in editor first.", "Error", 0)
end

function patchLegato()
  item = reaper.GetMediaItem(0, 0)
  position = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
  offset = reaper.GetMediaItemTakeInfo_Value(take, 'D_STARTOFFS')
  qn = reaper.TimeMap2_timeToQN(nil, position - offset)
  ppq = math.abs(reaper.MIDI_GetPPQPosFromProjQN(take, qn + 1))
  take_name = reaper.GetTakeName(take)
  bpm, bpi = reaper.GetProjectTimeSignature2()
  totalcnt, notecnt, cccnt = reaper.MIDI_CountEvts(take);
  sel_mode = false
  
  ppq = 960 -- PPQ value override
  
  ::proceed::
  if string.match(take_name, " #LEG") and warning ~= 6 then
    warning = reaper.ShowMessageBox("This take has already been patched for legato! Do you want to proceed anyway?", "Warning", 4)
    if warning == 6 then
      goto proceed
    end
  else
    local ticktime = 60000 / (bpm * ppq)
    legato_type = reaper.ShowMessageBox("For Expressive legato click YES, for Low-latency legato press NO", "Expressive or Low-latency legato?", 4)
    
    for i=notecnt, 0, -1 do
      local all, sel, muted, nstart, nend, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
      if sel ~= false then
        sel_mode = true
      end
    end
    for i=notecnt, 0, -1 do
      local all, sel, muted, nstart, nend, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
      if sel_mode == true and sel == false then
        goto continue
        
      -- Expressive legato
      elseif legato_type == 6 and vel >= 0 and vel <= 64 then
        local diff = exp_legato_slow / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      elseif legato_type == 6 and vel >= 65 and vel <= 100 then
        local diff = exp_legato_medium / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      elseif legato_type == 6 and vel >= 101 and vel <= 127 then
        local diff = exp_legato_fast / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
        
      -- Low-latency legato
      elseif legato_type == 7 and vel >= 0 and vel <= 64 then
        local diff = ll_legato_medium / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      elseif legato_type == 7 and vel >= 65 and vel <= 127 then
        local diff = ll_legato_fast / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      end
      ::continue::
    end
    reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", take_name .. " #LEG_W", true)
    drawInfo()
  end
  reaper.UpdateArrange()
end

function drawInfo()
  if sel_mode == true then
    sel_mode = "ONLY SELECTED"
    else sel_mode = "ALL"
  end
  reaper.ShowMessageBox("Take '" .. take_name .. "' was patched for CSW Expressive legato.\n\n" .. sel_mode .. " notes in the take were affected using following parameters:\nBPM: " .. string.format("%d", bpm) .. "\nPPQ: " .. string.format("%d", ppq) .. "\n\nDo not forget to rearrange each first note in passage if needed.", "Information", 0)
end

function Main()
  take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
  if take then
    patchLegato()
    else takeError()
  end
end

Main()
