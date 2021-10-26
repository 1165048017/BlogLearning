this script is used to descript the problems in `animmorph` and `mcjobjstomorphingprop`

the video demonstarte is here:https://youtu.be/AQuM2BCCBq0

# `AnimMorph`

git url : https://github.com/versluis/animmorph

**Attention**: there are no problem while loading short length obj sequence. The follow problems only occur while loading long sequence.

- problem 1 reproduce steps:
  - load cloth from DAZ contents
  - load obj sequences from Edit->Object->Morph Loader Pro
  - error: the loaded animation length is not the same as obj sequence length
  - error: the DAZ will lose response soon
- problem 2 reproduce steps:
  - load cloth from obj sequences ( the first one)
  - load obj sequences from Edit->Object->Morph Loader Pro
  - error: the DAZ will lose response soon

# mcjobjstomorphingprop

description and download url:https://sites.google.com/site/mcasualsdazscripts2/mcjobjstomorphingprop

There are no problem while using it.

But use this tool load obj sequences is tooooooooooo slow.

# modify version

I modified the `mcjobjstomorphingprop` , and we should :

- load cloth from DAZ contents
- load obj sequences from Edit->Object->Morph Loader Pro
- skip `Objs to Morphs ` step, because we load it as the first two steps
- set the `Timeline` range in DAZ and then set `morph animation` in pop window, click `Animate morphs` directly. That will make the animation timeline very fast.
