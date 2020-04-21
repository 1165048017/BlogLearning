function mocapClassVisualise(call)

% MOCAPCLASSVISUALISE Callback function for visualising mocap data.

global visualiseInfo
persistent st
persistent basePosition
switch call
 case 'click'
  visualiseInfo.clicked = ~visualiseInfo.clicked;
 
 case 'move'
  if visualiseInfo.clicked
    [x, y]  = localCheckPointPosition(visualiseInfo);  
    if ~isempty(x) 
      if isempty(st)
        st = cputime;
      end
      set(visualiseInfo.latentHandle, 'xdata', x, 'ydata', y);
      channels = ivmOut(visualiseInfo.model, [x y]);
      if ~isempty(visualiseInfo.velocityIndices)
        if isempty(basePosition)
          basePosition = zeros(1, length(visualiseInfo.velocityIndices));
        end
        basePosition = basePosition ...
            + channels(1, visualiseInfo.velocityIndices)/0.033*(cputime-st);
        st = cputime;
        channels(visualiseInfo.velocityIndices) = basePosition;
      end
      visualiseInfo.fhandleModify(visualiseInfo.visHandle, ...
                                  channels, ...
                                  visualiseInfo.bvhStruct);
      visualiseInfo.channels = channels;
      visualiseInfo.latentPos = [x, y];
    else
      st = cputime;
    end
  end
end




function point = localGetNormCursorPoint(figHandle)

point = get(figHandle, 'currentPoint');
figPos = get(figHandle, 'Position');
% Normalise the point of the curstor
point(1) = point(1)/figPos(3);
point(2) = point(2)/figPos(4);

function [x, y] = localGetNormAxesPoint(point, axesHandle)

position = get(axesHandle, 'Position');
x = (point(1) - position(1))/position(3);
y = (point(2) - position(2))/position(4);
lim = get(axesHandle, 'XLim');
x = x*(lim(2) - lim(1));
x = x + lim(1);
lim = get(axesHandle, 'YLim');
y = y*(lim(2) - lim(1));
y = y + lim(1);


function [x, y] = localCheckPointPosition(visualiseInfo)

% Get the point of the cursor
point = localGetNormCursorPoint(gcf);

% get the position of the axes
position = get(visualiseInfo.plotAxes, 'Position');


% Check if the pointer is in the axes
if point(1) > position(1) ...
      & point(1) < position(1) + position(3) ...
      & point(2) > position(2) ...
      & point(2) < position(2) + position(4);
  
  % Rescale the point according to the axes
  [x y] = localGetNormAxesPoint(point, visualiseInfo.plotAxes);

  % Find the nearest point
else
  % Return nothing
  x = [];
  y = [];
end
