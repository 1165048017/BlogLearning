function [model, bvhStruct, frameLength] = bvhLoadResult(dataSet, number)

% BVHLOADRESULT Load a previously saved result.

[bvhStruct, channels, frameLength] = bvhLoadData(dataSet);

dataSet(1) = upper(dataSet(1));
load(['dem' dataSet num2str(number)])
model = ivmReconstruct(kern, noise, ivmInfo, X, channels);
