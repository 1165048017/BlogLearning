function [meanOut, varOut] = manifoldOutputs(X2, X, Y, theta, invK)

% MANIFOLDOUTPUTS Evaluate the manifold output for datapoints X.

global LINEAR

dataDim = size(Y, 2);
numData = size(Y, 1);
numDataTest = size(X2, 1);

alpha = zeros(numData, dataDim);

kbold = kernel(X2, X, theta)';

A = Y'*invK;
meanOut = A*kbold;
meanOut = meanOut';
varOut = zeros(numDataTest, 1);
for i = 1:numDataTest
  varOut(i) = theta(2) +1/theta(end) - kbold(:, i)'*invK*kbold(:, i); 
end
