% DEMSWAGGER1 Demonstrate motion capture on swagger data --- uses recent GPLVM toolbox..

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'swagger';
experimentNo = 1;
% load data
[Y, connections] = mocapLoadData(dataSetName);
Y = Y/400;
%Y = Y(1:5:end, :);

% Set IVM active set size and iteration numbers.
options = gplvmOptions;

% Set all points as active
numActive = 40; %size(Y, 1)/3;

% Optimise kernel parameters and active set jointly.
%options.gplvmKern = 1;
options.extIters = 3;
% Display iterations
options.display = 0;
options.initX = 'sppca';


% Fit the GP latent variable model
selectionCriterion = 'entropy';
noiseType = 'gaussian';
kernelType = {'mlp', 'bias', 'white'};
model = gplvmFit(Y, 2, options, kernelType, noiseType, selectionCriterion, numActive);

% Save the results.
[X, kern, noise, ivmInfo] = gplvmDeconstruct(model);


% Save the results.
X = model.X;  
[kern, noise, ivmInfo] = ivmDeconstruct(model);
capName = dataSetName;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'X', 'kern', 'noise', 'ivmInfo');

% Load the results and display dynamically.
gplvmResultsDynamic(dataSetName, experimentNo, 'stick', connections)

% Load the results and display statically.
% gplvmResultsStatic(dataSetName, experimentNo, 'vector')

% Load the results and display as scatter plot
% gplvmResultsStatic(dataSetName, experimentNo, 'none')
