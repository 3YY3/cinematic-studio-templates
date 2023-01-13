--[[
Cinematic Studio Brass (CSB) Legato Patcher
CSB_legato_patcher.lua
Copyright © 2023 3YY3, MIT License
Not affiliated with Cinematic Studio Series in any way.
To be used with 3YY3 Cinematic Studio Series templates.
]]--

legato_medium = 170 -- 230 ms minus 60 ms already taken on the track to compensate short notes
legato_medium_t = 120 -- 180 ms minus 60 ms already taken on the track to compensate short notes
legato_fast = 40 -- 100 ms minus 60 ms already taken on the track to compensate short notes

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
  ins_type = 0
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
    ins_type = reaper.ShowMessageBox("Is this Trumpet?", "Choose the instrument", 4)
    
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
      elseif ins_type == 7 and vel >= 0 and vel <= 64 then
        local diff = legato_medium / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      elseif ins_type == 6 and vel >=0 and vel <=64 then
        local diff = legato_medium_t / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      elseif vel >= 65 and vel <= 127 then
        local diff = legato_fast / ticktime
        math.floor(diff)
        reaper.MIDI_SetNote(take, i, false, false, nstart - diff)
      end
      ::continue::
    end
    reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", take_name .. " #LEG_B", true)
    drawInfo()
  end
  reaper.UpdateArrange()
end

function drawInfo()
  if sel_mode == true then
    sel_mode = "ONLY SELECTED"
    else sel_mode = "ALL"
  end
  if ins_type == 6 then
    ins_type = "trumpet"
    else ins_type = "trombones, horns or tuba"
  end
  reaper.ShowMessageBox("Take '" .. take_name .. "' was patched for CSB legato.\n\n" .. sel_mode .. " notes in the take were affected using following parameters:\nBPM: " .. string.format("%d", bpm) .. "\nPPQ: " .. string.format("%d", ppq) .. "\nInstrument: " .. ins_type .. "\n\nDo not forget to rearrange each first note in passage if needed.", "Information", 0)
end

function Main()
  take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
  if take then
    patchLegato()
    else takeError()
  end
end

Main()
