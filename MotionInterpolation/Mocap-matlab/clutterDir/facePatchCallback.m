function facePatchCallback(call, input)

% FACEPATCHCALLBACKHANDLER Function for handling call backs from draw window.

global PATCHINFO
global visualiseInfo

switch call
 case 'click'
  [x, y]  = localCheckPointPosition(PATCHINFO);  
%  fprintf('%f, %f\n', x, y)
  % If the pointer was not in the axes the values will be empty 
  if ~isempty(x)
    %fprintf('%f, %f\n', x, y)
    % toggle move mode.
    PATCHINFO.moveMode = ~PATCHINFO.moveMode;
    % find nearest point.
    if PATCHINFO.moveMode
      % MOve indicator to the node you connected to.
      PATCHINFO.index = localClosestPoint(x, y);
      set(PATCHINFO.indicatorPoint, 'xdata', PATCHINFO.points(PATCHINFO.index, 1), ...
                        'ydata', PATCHINFO.points(PATCHINFO.index, 3));%, ...
%                        'zdata', PATCHINFO.points(PATCHINFO.index, 3));
      set(PATCHINFO.indicatorPoint, 'visible', 'on')
%      fprintf('%f, %f\n', x, y)
    else
      set(PATCHINFO.indicatorPoint, 'visible', 'off')
    end
  end
     
 case 'move'
  
  if PATCHINFO.moveMode %you are moving the point
    [x, y] = localCheckPointPosition(PATCHINFO);  
    if ~isempty(x)
      %      fprintf('%f, %f\n', x, y);
      yval = repmat(NaN, 1, size(PATCHINFO.points, 1)*3);
      alpha = 0;
      yval(PATCHINFO.index) = x*(1-alpha) + ...
          PATCHINFO.points(PATCHINFO.index, 1)*alpha;
      yval(PATCHINFO.index+size(PATCHINFO.points, 1)*2) = y*(1-alpha) + ...
          PATCHINFO.points(PATCHINFO.index, 3)*alpha;
      options = foptions;
      options(14) = 100;
      %      options(9) = 1;
      %      options(1) = 1;
      visualiseInfo.latentPos = scg('pointNegLogLikelihood', ...
                                    visualiseInfo.latentPos, options, 'pointNegGrad', ...
                                    yval-visualiseInfo.meanData, visualiseInfo.X, ...
                                    visualiseInfo.A, ...
                                    visualiseInfo.theta, ...
                                    visualiseInfo.invSigma, ...
                                    visualiseInfo.labelInfo(visualiseInfo.currentModel).mean, ...
                                    visualiseInfo.labelInfo(visualiseInfo.currentModel).cov);
      vals = manifoldOutputs(visualiseInfo.latentPos, ...
                             visualiseInfo.X, visualiseInfo.Y, ...
                             visualiseInfo.theta, visualiseInfo.invSigma);
      
      vals = vals + visualiseInfo.meanData;
      vals(PATCHINFO.index) = vals(PATCHINFO.index)*1 + x*(alpha);
      vals(PATCHINFO.index+size(PATCHINFO.points, 1)*2) = ...
          vals(PATCHINFO.index+size(PATCHINFO.points, 1)*2)*1 ...
          + y*(alpha);
%      fprintf('moving point %d\n', PATCHINFO.index);
      set(PATCHINFO.indicatorPoint, ...
          'xdata', vals(PATCHINFO.index), ...
          'ydata', vals(PATCHINFO.index+size(PATCHINFO.points, 1)*2));%, ...
      feval(visualiseInfo.visualiseModify, visualiseInfo.visHandle, vals, visualiseInfo.varargin{:});
      set(visualiseInfo.latentHandle, 'xdata', visualiseInfo.latentPos(1), ...
                        'ydata', visualiseInfo.latentPos(2));
      
    end
    
  end

 case 'sigmaChange'
  logvar = get(gcbo, 'Value');
  visualiseInfo.theta(end) = 10^-logvar;
  set(PATCHINFO.sigmaLabel, 'String', ['Variance: ' num2str(10^logvar)]);
 
 case 'radioClick'
  visualiseInfo.currentModel = input;
  for i = 1:length(PATCHINFO.labelRadio)
    set(PATCHINFO.labelRadio(i), 'value', 0);
  end
  set(PATCHINFO.labelRadio(input), 'value', 1);
  
end

function index = localClosestPoint(x, y)

% LOCALCLOSESTPOINT Return the closest point to x, y.

global PATCHINFO

%projectionMatrix = localProjectMatrix(PATCHINFO.plotAxes);
projectionTwoD = [PATCHINFO.points(:, 1) PATCHINFO.points(:, 3)];
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
y = y*(lim(2) - lim(1));
y = y + lim(1);


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



