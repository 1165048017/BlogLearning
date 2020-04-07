function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize);

numCases = size(data, 2);

groundTruth = full(sparse(labels, 1:numCases, 1));
cost = 0;

thetagrad = zeros(numClasses, inputSize);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.

M = exp(theta*data);
M = bsxfun(@rdivide, M, sum(M));
cost = (-1/size(data,2)).*sum(sum(groundTruth.*log(M)));
cost = cost + (lambda/2).*sum(sum(theta.^2));

thetagrad = (-1/size(data,2)).*(((groundTruth-(M))*data') + (lambda*theta));

% figure(2);
% display_network(extra.sae1OptTheta...
%     *extra.sae2OptTheta...
%     *theta'...
%     *log(M(:,[1:10 end-9:end])));                          



% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = [thetagrad(:)];
end

