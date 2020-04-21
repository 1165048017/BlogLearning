function g = pointNegGrad(x, y, X, A, theta, invK, m, C) %(x_i, i, A, invK, X, Y, D, theta)

% POINTNEGGRAD Compute gradient of data-point likelihood wrt x.

if nargin < 7
  m = [0 0];
  C = [1 0; 0 1];
end

presentInd = find(~isnan(y));
Atemp = A(presentInd, :);
D = length(presentInd);  


kbold = kernel(x, X, theta)';
f = Atemp*kbold;
sigma2 = theta(2) +1/theta(end) - kbold'*invK*kbold; 
yHat_i = y(presentInd)' - f;


if sigma2 < 1e-6;
  sigma2 = 1e-6;
end


prePart = theta(1)/sigma2*(yHat_i'*Atemp) +theta(1)/sigma2*(D-yHat_i'*yHat_i/sigma2)*kbold'*invK;

g = zeros(size(x));
for k = 1:length(x)
  g(k) = prePart*((x(k) - X(:, k)).*kbold);
end

g = g + (x-m)*pdinv(C);

% kbold = kernel(x_i, activeX, theta)';
% f = A*kbold;
% sigma2 = theta(2) +1/theta(end) - kbold'*invK*kbold; 
% yHat_i = Y(i, :)' - f;


% if sigma2 < 1e-6;
%   sigma2 = 1e-6;
% end


% prePart = theta(1)/sigma2*(yHat_i'*Y(activeSet, :)'+(D-yHat_i'*yHat_i/sigma2)*kbold')*invK;

% g = zeros(size(x_i));
% for k = 1:length(x_i)
%   g(k) = prePart*((x_i(k) - activeX(:, k)).*kbold);
% end

% g = g + x_i;