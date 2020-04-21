% DEMEA1 Iterate the face data from 2_2 to convergence.

% Keep results consistent each time run
rand('seed', 1e5)
randn('seed', 1e5)

colordef white
%connections = mocapFaceConnections('../data/manuel/connections.txt');
%connections(:, 73:end) = [];
%connections(73:end, :) = [];
patches = mocapFacePatches('../data/manuel/patches.txt');
for i = 1:4
  patches(i).colour = zeros(size(patches(i).colour));
end
indToDel = [];
for i = 1:length(patches)
  if any(patches(i).index > 72)
    indToDel = [indToDel i];
  end
end
patches(indToDel) = [];

vals = load('../data/manuel_wo_rbt/2_2.dat');
lastMarker = 72*3+1;
points{1} = vals(:, 2:3:lastMarker);
points{2} = vals(:, 3:3:lastMarker);
points{3} = vals(:, 4:3:lastMarker);
for i = 1:3
%  vals = points{i}(:, 3) + points{i}(:, 50) + points{i}(:, 60);
%  vals = vals/3;
%  for j = 1:size(points{i}, 2);
%    points{i}(:, j) = points{i}(:, j) - vals;
%  end
end
Y = [points{1} points{3} points{2}]*4;
importTool('ndlutil')
latentDim = 2;

% Select data
%numData = 100;
%indices = randperm(size(points, 1));
%indices = indices(1:numData);
%Y = points(indices, :);
Y = Y(1:20:end, :);

numData = size(Y, 1);
fprintf('Num Data %d\n', numData);
meanData = mean(Y);

Y = Y - repmat(meanData, numData, 1);
dataDim = size(Y, 2);
lbls = ones(size(Y, 1), 1);

% Initialise X with PCA - just for fun let's do it with the eigenvalue
% problem
[Lambda, U] = pca(Y');
beta = 1/Lambda(3);
L(1, 1) = sqrt(Lambda(1) -1/beta);
L(2, 2) = sqrt(Lambda(2) -1/beta);
X(:, 1) = U(:, 1);
X(:, 2) = U(:, 2);
X = X*L;
invK = pdinv(X*X'+1/beta*eye(numData));
theta = [1 1 beta];

returnVal = [];

symbol{1} = 'r+';
symbol{2} = 'bo';
symbol{3} = 'mx';
plot(X(:, 1), X(:, 2), 'rx');


% initialise kernel parameters
theta = [1 1 beta];
lntheta = log(theta);

params = [X(:)' lntheta];

options = foptions;
options(1) = 1;
options(9) = 0;
options(14) = 20000;

% by not passing X to scg it is automatically optimised
params = scg('gplvmlikelihood', params, options, 'gplvmgradient', Y);

X = reshape(params(1:numData*latentDim), numData, latentDim);
lntheta = params(numData*latentDim+1:end);
theta = exp(lntheta);

[K, invK] = computeKernel(X, theta);
labelInfo(1).text = 'Neutral';
labelInfo(1).indices = [1:20]';
labelInfo(2).text = 'Happy';
labelInfo(2).indices = [21:27 96:105]';
labelInfo(3).text = 'Sad';
labelInfo(3).indices = [30:38]';
labelInfo(4).text = 'Fear';
labelInfo(4).indices = [40:47]';
labelInfo(5).text = 'Suprise';
labelInfo(5).indices = [49:58]';
labelInfo(6).text = 'Anger';
labelInfo(6).indices = [60:68]';
labelInfo(7).text = 'Disgust';
labelInfo(7).indices = [70:78]';
labelInfo(8).text = 'Maniac';
labelInfo(8).indices = [80:95]';
labelInfo(9).text = 'Transition';
labelInfo(9).indices = [28:29 39 48 59 69 79]';

% Visualise the results
mocapFaceVisualise(X, Y, invK, theta, [], meanData, 1:numData, ...
                   labelInfo, 'face2DVisualise', 'face2DModify', patches);

%save demEa1.mat X Y invK theta meanData patches