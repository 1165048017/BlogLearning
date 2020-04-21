% Keep results consistent each time run
rand('seed', 1e5)
randn('seed', 1e5)

points = stickmanResample(points, 100);

latentDim = 2;

% Select data
numData = 100;
indices = randperm(size(points, 1));
indices = indices(1:numData);
Y = points(indices, :);
% Y = points;
lbls = zeros(size(points, 1), 3);


meanData = mean(Y);
Y = Y - repmat(meanData, numData, 1);

dataDim = size(Y, 2);


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
theta = [0 1 beta];

returnVal = [];

symbol{1} = 'r+';
symbol{2} = 'bo';
symbol{3} = 'mx';
figure, hold on
for i = 1:size(X, 1)
  labelNo = find(lbls(i, :));
  plot(X(i, 1), X(i, 2), symbol{labelNo})
end


% initialise kernel parameters
theta = [1 1 beta];
lntheta = log(theta);

params = [X(:)' lntheta];

options = foptions;
options(1) = 1;
options(9) = 0;
options(14) = 5000;

% by not passing X to scg it is automatically optimised
params = scg('gplvmlikelihood', params, options, 'gplvmgradient', Y);

X = reshape(params(1:numData*latentDim), numData, latentDim);
lntheta = params(numData*latentDim+1:end);
theta = exp(lntheta);

[K, invK] = computeKernel(X, theta);

% Visualise the results
gplvmvisualise(X, Y, invK, theta, [], meanData, 1:numData, 'stickmanGplvmVisualise', 'stickmanGplvmModify', connection);
