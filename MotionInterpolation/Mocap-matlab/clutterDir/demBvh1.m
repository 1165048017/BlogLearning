% function bvhModel(dataSet)

% BVHMODEL Model Demonstration of modelling of BVH files.

rand('seed', 1e5)
randn('seed', 1e5)
colordef white

fileName = [dataSet '.bvh'];

[bvhStruct, channels, frameLength] = bvhReadFile(fileName);

% COnvert root's channels into velocities
rootIndices = 1;
for i = 2:size(channels, 1)
  for j = rootIndices
    for k = bvhStruct(j).posInd
      channels(i-1, k) = channels(i, k) - channels(i-1, k);
    end
    for k = bvhStruct(j).rotInd
      channels(i-1, k) = channels(i, k) - channels(i-1, k);
    end
  end
end

latentDim = 2;

Y = channels(1:4:end, :);

numData = size(Y, 1);
dataDim = size(Y, 2);
fprintf('Num Data %d\n', numData);

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
options(14) = 200;

% by not passing X to scg it is automatically optimised
params = scg('gplvmlikelihood', params, options, 'gplvmgradient', Y);

X = reshape(params(1:numData*latentDim), numData, latentDim);
lntheta = params(numData*latentDim+1:end);
theta = exp(lntheta);

[K, invK] = computeKernel(X, theta);

% Visualise the results
mocapVisualise(X, Y, invK, theta, ones(size(Y, 1), 1), meanData, ...
               1:numData, 'bvhVisualise', 'bvhModify', bvhStruct, 0);

%save([demEaStick.mat X Y invK theta meanData numData connect