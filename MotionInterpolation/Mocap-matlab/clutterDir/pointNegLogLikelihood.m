function e = pointNegLogLikelihood(x, y, X, A, theta, invK, m, C)

% POINTNEGLOGLIKELIHOOD Wrapper function for calling noise likelihoods.

L = modelLogLikelihood(x, y, X, A, theta, invK);
if nargin < 7
  m = [0 0];
  C = [1 0; 0 1];
end
L = L - .5*(x-m)*pdinv(C)*(x-m)';
e = -L;

function logLike = modelLogLikelihood(x, y, X, A, theta, invK);

presentInd = find(~isnan(y));
Atemp = A(presentInd, :);

kbold = kernel(x, X, theta)';
meanOut = Atemp*kbold;
meanOut = meanOut';
varOut = theta(2) +1/theta(end) - kbold'*invK*kbold; 
ycent = (y(presentInd) - meanOut);
logLike = -0.5*length(presentInd)*log(varOut) - ycent*ycent'/(2*varOut);

