function theta = thetaConstrain(theta)

% THETACONSTRAIN Prevent kernel parameters from getting too big or small.

minTheta = 1e-6;
maxTheta = 1/minTheta;

if any(theta < minTheta)
  theta(find(theta<minTheta)) = minTheta;
elseif any(theta>maxTheta)
  theta(find(theta>maxTheta)) = maxTheta;
end
