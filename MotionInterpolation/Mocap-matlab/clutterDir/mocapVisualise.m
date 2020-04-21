function mocapVisualise(model, YLbls, ...
			fhandleVisualise, fhandleModify, bvhStruct, ...
                        velocityIndices)

% MOCAPVISUALISE Visualise the manifold.

% derived from gplvmVisualise from an early version of the gplvm toolbox.
global visualiseInfo


visualiseInfo.velocityIndices = velocityIndices;
visualiseInfo.bvhStruct = bvhStruct;
numData = size(model.y, 1);
if nargin < 6
  YLbls = ones(numData, 1);
end
  
figure(1)
visualiseInfo.plotAxes = gplvmScatterPlot(model, YLbls);
xLim = [min(model.X(:, 1)) max(model.X(:, 1))];
xSpan = xLim(2) - xLim(1);
xLim(1) = xLim(1) - 0.05*xSpan;
xLim(2) = xLim(2) + 0.05*xSpan;
xSpan = xLim(2) - xLim(1);

yLim = [min(model.X(:, 2)) max(model.X(:, 2))];
ySpan = yLim(2) - yLim(1);
yLim(1) = yLim(1) - 0.05*ySpan;
yLim(2) = yLim(2) + 0.05*ySpan;
ySpan = yLim(2) - yLim(1);

set(visualiseInfo.plotAxes, 'XLim', xLim)
set(visualiseInfo.plotAxes, 'YLim', yLim)

visualiseInfo.latentHandle = line(0, 0, 'markersize', 20, 'color', ...
                                  [0 0 0], 'marker', '.', 'visible', ...
                                  'on', 'erasemode', 'xor');
visualiseInfo.clicked = 0;
visualiseInfo.digitAxes = [];
visualiseInfo.digitIndex = [];

% Set the callback function
set(gcf, 'WindowButtonMotionFcn', 'mocapClassVisualise(''move'')')
set(gcf, 'WindowButtonDownFcn', 'mocapClassVisualise(''click'')')

figure(2)
clf
[void, indMax]= max(sum((model.y.*model.y), 2));
visData = model.y(indMax, :);
imageAxesa =subplot(1, 1, 1);
visHandle = fhandleVisualise(visData, bvhStruct);
%set(visHandle, 'erasemode', 'xor')
visualiseInfo.model = model;
visualiseInfo.fhandleModify = fhandleModify;
visualiseInfo.visHandle = visHandle;
hold off

