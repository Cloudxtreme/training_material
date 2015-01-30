Basho Training Material
=======================

## Description

The official repository for Basho-approved training material.

Please read the following guidelines carefully. Legacy material that does not follow the rules is in the unsorted folder pending update. This material may be used for training while there is no up-to-date alternative, but if you do present it please consider updating it yourself afterwards if you have time.

## Guidelines

### Timing

+ a single unit module covers 20 minutes of actual teaching time plus a short break at the end
+ a double unit module covers 40 minutes of teaching time, plus one break in the middle and another at the end
+ breaks should last a minimum of 5 minutes
+ after running three or four modules, a longer break of 30 minutes should be given

### Presentation

+ each module should include some practical element, e.g. demonstration, exercise
+ lab modules, focusing on longer exercises, are encouraged
+ modules should be presentable, in a consistent fashion, by any knowledgeable person
+ to this end, every slide, demo and exercise should have:
 + concise in-presentation speaker notes for use during presentations
 + extensive accompanying teaching notes for study before presentations, including full transcripts where possible

### Content

+ every slide should serve a specific teaching purpose
+ pictures, diagrams, code or text should reinforce or demonstrate the concept being described
+ slides should not contain the text that is spoken out loud (except titles)
+ modules may have prerequisites of other modules, but this should be kept to a minimum to allow trainers to pick and mix effectively
+ a module should not be presented to customers unless it is:
 + retrieved from this training material repo
 + applicable to the product & version the training is targeted towards
 + reviewed for correctness within the last three months

### Metadata & Review

+ metadata for all modules is stored in the Index file at the root of this repo
+ modules should not be committed to this repo without the following metadata:
 + Title
 + Units
 + Applicable Software Version(s)
 + Teaching Objectives
 + Prerequisites (or none if none)
 + Reviewed Correct and Current (by whom? when? for which version(s)?)
+ a module should not be approved by a reviewer unless it:
 + meets all the above criteria
 + is factually correct
 + fulfills the stated teaching objectives
 + applies to all versions the author has listed

### Versions & Naming

+ author's discretion applies with regards to how many software versions a particular presentation should attempt to cover. If a new version implies only a few minor changes, these can be listed under version sub-headings within the original presentation; whereas if the differences are widespread or conceptually substantial, a fresh copy of the presentation should be stored in the repo that applies only to the new software version with all outdated information removed
+ under no circumstances should presentations applying to previous software versions be overwritten, or even allowed to sink into version control history, because these presentations may still be used; rather entirely new copies should be reposited
+ presentations should be placed in subfolders by version, e.g.
 + 1.4/Bitcask_Backend
 + 2.0/Bitcask_Backend
 + etc.

### Format

+ teaching notes should be in plaintext or markdown
+ slideshows should be in keynote, powerpoint, or markdown
