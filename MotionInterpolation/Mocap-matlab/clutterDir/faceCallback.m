function faceCallback(call)

% FACECALLBACKHANDLER Function for handling call backs from draw window.

global PATCHINFO
persistent POINTNO
switch call
 case 'click'
  [x, y]  = localCheckPointPosition(PATCHINFO);  
  fprintf('%f, %f\n', x, y)
  % If the pointer was not in the axes the values will be empty 
  if ~isempty(x)
    %fprintf('%f, %f\n', x, y)
    % toggle move mode.
    PATCHINFO.moveMode = ~PATCHINFO.moveMode;
    % find nearest point.
    if PATCHINFO.moveMode
      % MOve indicator to the node you connected to.
      index = localClosestPoint(x, y);
      set(PATCHINFO.indicatorPoint, 'xdata', PATCHINFO.points(index, 1), ...
                        'ydata', PATCHINFO.points(index, 2), ...
                        'zdata', PATCHINFO.points(index, 3));
      set(PATCHINFO.indicatorPoint, 'visible', 'on')
      fprintf('%f, %f\n', x, y)
    else
      set(PATCHINFO.indicatorPoint, 'visible', 'off')
    end
  end
     
 case 'move'
  
  if PATCHINFO.moveMode %you are moving the point
    [x, y] = localCheckPointPosition(PATCHINFO);  
    if ~isempty(x)
      pointThreeD = [x y]*pinv(localProjectMatrix(PATCHINFO.plotAxes));
      fprintf('%f, %f, %f\n', [pointThreeD(1), pointThreeD(2), pointThreeD(3)])
      
      % move the point --- need to look up on patches what is
      % connected where.
      
      %    set(PATCHINFO.positionTxt, ...
      %        'String', [num2str(x) ', ' num2str(y)]);
      
      %    set(PATCHINFO.drawFigure, 'Pointer', 'fullcrosshair')

    end
  end
end

function index = localClosestPoint(x, y)

% LOCALCLOSESTPOINT Return the closest point to x, y.

global PATCHINFO

projectionMatrix = localProjectMatrix(PATCHINFO.plotAxes);
projectionTwoD = PATCHINFO.points*projectionMatrix;
distance = dist2([x y], projectionTwoD);
[void, index] = min(distance);

function U = localProjectMatrix(axesHandle)

% LOCALPROJECTMATRIX Projec the 3-D points onto the current observed plane.

% Project points onto the given plane.  --- need to make sure axes
% are correct --- also need to set up scale.
camPos = get(axesHandle, 'cameraposition')'; % where is the camera.
camTar = get(axesHandle, 'cameratarget')'; % where does camera point
camUp = get(axesHandle, 'cameraupvector'); % which axes is up
camPoint = camPos - camTar;
camPoint = camPoint/sqrt(camPoint'*camPoint);
% deflate the camera position from the unit matrix.
[U, V] = eig(eye(3) - camPoint*camPoint');
[void, indRemove] = min(diag(V));
U(:, indRemove) = [];
  



function point = localGetNormCursorPoint(figHandle)

% LOCALGETNORMCURSORPOINT Get the position of the cursor in a normalised way.

point = get(figHandle, 'currentPoint');
figPos = get(figHandle, 'Position');
% Normalise the point of the curstor
point(1) = point(1)/figPos(3);
point(2) = point(2)/figPos(4);

function [x, y] = localGetNormAxesPoint(point, axesHandle)

% LOCALGETNORMAXESPOINT Get the position of the cursor from the axes.

position = get(axesHandle, 'Position');
x = (point(1) - position(1))/position(3);
y = (point(2) - position(2))/position(4);
lim = get(axesHandle, 'XLim');
x = x*(lim(2) - lim(1));
x = x + lim(1);
lim = get(axesHandle, 'YLim');
y = y*(lim(1) - lim(2));
y = y + lim(2);


function [x, y] = localCheckPointPosition(PATCHINFO)

% LOCALCHECKPOINTPOSITION Check if the cursor is in the axes.

% Get the point of the cursor
point = localGetNormCursorPoint(PATCHINFO.drawFigure);

% get the position of the axes
position = get(PATCHINFO.plotAxes, 'Position');


% Check if the pointer is in the axes
if point(1) > position(1) ...
      & point(1) < position(1) + position(3) ...
      & point(2) > position(2) ...
      & point(2) < position(2) + position(4);
  
  % Rescale the point according to the axes
  [x y] = localGetNormAxesPoint(point, PATCHINFO.plotAxes);

else
  % Return nothing
  x = [];
  y = [];
end



