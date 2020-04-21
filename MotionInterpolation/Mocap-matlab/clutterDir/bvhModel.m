function bvhModel(dataSet, experimentNo)

% BVHMODEL Model Demonstration of modelling of BVH files.

rand('seed', 1e5)
randn('seed', 1e5)
colordef white

[bvhStruct, Y, frameLength, velocityIndices] = bvhLoadData(dataSet);

numActive = min([50 size(Y, 1)]);
% Fit the GP latent variable model
switch experimentNo
 case 1
  kernelType = {'rbf', 'bias', 'white'};
 case 2
  kernelType = {'mlp', 'bias', 'white'};
end
options = bvhOptions;

model = gplvmFit(Y, 2, options, kernelType, 'gaussian', ...
                 'entropy', numActive)

% Save the results.
X = model.X;  
[kern, noise, ivmInfo] = ivmDeconstruct(model);
capName = dataSet;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'X', 'kern', ...
     'noise', 'ivmInfo');

%bvhResultsDynamic(dataSet, experimentNo, 'bvh', bvhStruct, velocityIndices)