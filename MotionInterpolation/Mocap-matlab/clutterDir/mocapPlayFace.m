function mocapPlayFace(Y, patches, model)

% MOCAPPLAYDATA 

% Load patches
% Compute any missing values

playY = Y;
if nargin > 2
  x = randn(2, 1);
  for i = 1:size(playY, 1)
    if any(isnan(playY(i, :)))
      x = scg('pointNegLogLikelihood', ...
              x, options, 'pointNegGrad', ...
              yval, model.X, ...
              model.A, ...
              model.theta, ...
              model.invSigma);
      playY(i, :) = manifoldOutputs(x, model.X, model.Y, ...
                                    model.theta, model.invSigma);
      notMissing = find(~isnan(Y(i, :)));
      playY(i, notMissing) = Y(i, notMissing);
    end
  end
end

pauseVal = 0.0001;
handle = facePatchVisualise(playY(1, :), patches);
for i = 1:size(playY, 1)
  facePatchModify(handle, playY(i, :), patches);
  drawnow
end
