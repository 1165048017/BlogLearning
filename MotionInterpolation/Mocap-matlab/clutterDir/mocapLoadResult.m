function [model, connect] = mocapLoadResult(dataSet, number)

% MOCAPLOADRESULT Load a previously saved result.

[Y, connect] = mocapLoadData(dataSet);

dataSet(1) = upper(dataSet(1));
load(['dem' dataSet num2str(number)])
model = ivmReconstruct(kern, noise, ivmInfo, X, Y);
