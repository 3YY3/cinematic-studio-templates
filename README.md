# cinematic-studio-templates
Ready-to-Play [Reaper](https://www.reaper.fm/) track templates, legato patches and REAticulate templates for [Cinematic Studio series](https://cinematicstudioseries.com/) Kontakt instruments.
These templates have already -60 ms offset on MIDI tracks to allow you to work with the short articulations right away. The legato scripts then take care of long articulations delay (for an information on which is which take a look in the PDFs included with your Cinematic Studio libraries).
All articulations are located on only one MIDI track per instrument thanks to [REAticulate](https://reaticulate.com/).

## What is CSS, CSSS, CSW and CSB? 
Cinematic Studio series instruments are great tools for making orchestral/cinematic music. These four NI Kontakt instruments cover Strings, Woodwinds and Brass in orchestra, including solo instruments in more that enough cases.

## Prerequisites
This legato skripts are tailored to be used with:
- CSS version 1.7.1
- CSSS, CSB version 1.0.0
- CSW version 1.3.0
- VST3 Kontakt 6 version 6.7.1
- REAticulate

You can use track templates and legato scripts even if you own only one or some of the CS libraries. If you have a different version of Kontakt (or if something went wrong), you can load multi instruments in your version from [this folder](https://github.com/3YY3/cinematic-studio-templates/tree/main/kontakt_multis).

Unless you are a masochist, I strongly recommend using REAticulate. All articulations can be located on the same MIDI track that way (and in my [templates](https://github.com/3YY3/cinematic-studio-templates/tree/main/track_templates) they are).

## Why did I created the [legato scripts](https://github.com/3YY3/cinematic-studio-templates/tree/main/legato_scripts)?
Since Cinematic Studio philosophy on the legato is to have true sample with the legato transition, this transition takes some time after you press the key. This creates quite a problem because legato notes are then not played in the right beat but always a little late. Thanks to this you need to manually edit most legato notes start positions in your composition. 
You can of course compensate for this by setting negative offset on the track. However, there are multiple legato transition speeds in CS libraries (each producing different lag in milliseconds). If you choose to compensate in DAW, you are limited in this approach choosing only one of these speeds so that it fits every note (it also proves problematic when changing articulations on the same track).
This is where my scripts come in handy!

## General description
Load [track templates](https://github.com/3YY3/cinematic-studio-templates/tree/main/track_templates) as needed. Same goes for [REAticulate template](https://github.com/3YY3/cinematic-studio-templates/blob/main/Reaticulate.reabank), of which instances are already located on the MIDI tracks.

[Legato scripts](https://github.com/3YY3/cinematic-studio-templates/tree/main/legato_scripts) are used while in MIDI editor window. They change the starting position of each note in active take so that it corresponds with the beat.
If you intend to move every note in the take, do not select any of them. Just run the script and wait for magic to happen. If, however, you want to move only some of the notes, select them and run the script.
Remember that first notes in continuous legato move have to be right on the desired beat. Repair them after running the script, or simply do not choose them before running the script.
Script always marks the take with appropriate name suffix, so you know it was already patched (and also to make sure you do not run the script twice on some take).
