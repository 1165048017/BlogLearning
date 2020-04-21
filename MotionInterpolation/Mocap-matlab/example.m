%an example for reading and playing MOCAP data
skel=acclaimReadSkel('./data/13.asf');
[channels,skel ]=acclaimLoadChannels('./data/13_39.amc',skel);
skelPlayData(skel,channels,1/120)