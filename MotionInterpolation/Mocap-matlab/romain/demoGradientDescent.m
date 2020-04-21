% DEMOGRADIENTDESCENT  compute a gradient descent for an initial position
% and an end position of a human body


%you can modify the error value to make the channels get closer to the
%wanted channels
error  = 10;
step   = 0.01;


skel = acclaimReadSkel('07.asf');
[channels, skel] = acclaimLoadChannels('07_01.amc', skel);

channels(1,[1 2 3]) = [ 0 0 0 ];
channels(200,[1 2 3])= [ 0 0 0 ];
test = zeros(1,62);

%channelsFinal = gradientDescent(skel, channels(1,:), channels(200,:),error,step);
channelsFinal = gradientDescent(skel, channels(1,:), test,error,step);


figure(1)
subplot(2,2,1)
skelVisualise(channels(1,:), skel, -1);
title('initial position')
subplot(2,2,2)
%skelVisualise(channels(200,:), skel, -1);
skelVisualise(test, skel, -1);
title('final position')
subplot(2,2,3)
skelVisualise(channels(1,:), skel, -1);
%skelVisualise(channels(200,:), skel, -1);
skelVisualise(test, skel, -1);
title('initial and final  position')


figure(2)
skelPlayData(skel,channelsFinal,1/60);
%skelVisualise(channels(200,:), skel, -1);
skelVisualise(test, skel, -1);