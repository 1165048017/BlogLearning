
% DEMOFGPLVMSTEP2 Model steps of human  using an RBF kernel, dynamics, and
% several sequences.


clear

skel = acclaimReadSkel('07.asf');
[channels_01, skel] = acclaimLoadChannels('07_01.amc', skel);
[channels_04, skel] = acclaimLoadChannels('07_04.amc', skel);
[channels_05, skel] = acclaimLoadChannels('07_05.amc', skel);
[channels_11, skel] = acclaimLoadChannels('07_11.amc', skel);

[line_01 colums_01]= size(channels_01);
[line_04 colums_04]= size(channels_04);

%Delete the translation motion
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

% Add dynamics model.
options = gpOptions('ftc');
options.kern = kernCreate(model.X, {'rbf', 'white'});
options.kern.comp{1}.inverseWidth = 0.2;
% This gives signal to noise of 0.1:1e-3 or 100:1.
options.kern.comp{1}.variance = 0.1^2;
options.kern.comp{2}.variance = 1e-3^2;
model = fgplvmAddDynamics(model, 'gp', options,1,0,[17 35 62 78]);

iters = 500;
display = 1;

model = fgplvmOptimise(model, display, iters);

% Load the results and display dynamically.
lvmVisualise(model, 'connect', 'skelVisualise', 'skelModify', skel);


