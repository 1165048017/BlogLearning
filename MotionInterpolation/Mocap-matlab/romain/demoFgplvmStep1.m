
% DEMOFGPLVMSTEP1 Model steps of human  using an RBF kernel, and
% several sequences of step.


clear

skel = acclaimReadSkel('07.asf');
[channels_01, skel] = acclaimLoadChannels('07_01.amc', skel);
[channels_04, skel] = acclaimLoadChannels('07_04.amc', skel);
[channels_05, skel] = acclaimLoadChannels('07_05.amc', skel);
[channels_11, skel] = acclaimLoadChannels('07_11.amc', skel);



[line_01 colums_01]= size(channels_01);
[line_04 colums_04]= size(channels_04);

channels_04 = translateBody(channels_04,channels_01(60,3)-channels_04(59,3));
channels_05 = translateBody(channels_05,channels_01(60,3)-channels_05(30,3));
channels_11 = translateBody(channels_11,channels_01(60,3)-channels_11(26,3));


tmp = zeros(315,colums_01);
tmp(1:67,:) = channels_01(60:126,:);
tmp(68:139,:) = channels_04(59:130,:);
tmp(140:245,:) = channels_05(30:135,:);
tmp(246:315,:) = channels_11(26:95,:);

Y= zeros (78,colums_01);

for i=1:78
    Y(i,:)=tmp((i-1)*4+1,:);
end



% Set up model
% Train using the full training conditional (i.e. no approximation.)
options = fgplvmOptions('ftc');
latentDim = 2;

d = size(Y, 2);
model = fgplvmCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 500;
display = 1;

model = fgplvmOptimise(model, display, iters);

lvmVisualise(model, 'connect', 'skelVisualise', 'skelModify', skel);