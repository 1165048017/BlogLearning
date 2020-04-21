function mocapFaceVisualise(X, Y, invK, theta, YLbls, meanData, activeSet, ...
                            labelInfo, visualiseFunction, visualiseModify, varargin)

% MOCAPFACEVISUALISE Visualise the manifold.

global visualiseInfo
global PATCHINFO



symbol{1} = 'r+';
symbol{2} = 'bo';
symbol{3} = 'mx';
symbol{4} = 'g*';
symbol{5} = 'ys';
symbol{6} = 'rd';
symbol{7} = 'bV';
symbol{8} = 'm^';
symbol{9} = 'g<';
symbol{10} = 'y>';

activeX = X(activeSet, :);
activeY = Y(activeSet, :);

numData = size(Y, 1);
if nargin < 6
  YLbls = ones(numData, 1);
end

x1 = linspace(min(X(:, 1))*1.1, max(X(:, 1))*1.1, 200);
x2 = linspace(min(X(:, 2))*1.1, max(X(:, 2))*1.1, 200);
[X1, X2] = meshgrid(x1, x2);
XTest = [X1(:), X2(:)];
[testY, testYVar] = manifoldOutputs(XTest, activeX, activeY, theta, invK);

testYPlot = testY;
testYPlot(find(testYVar>prctile(testYVar(:, 1), 25))) =NaN;
  
figure(1)
clf
% Create the plot for the data
clf
visualiseInfo.plotAxes = axes('position', [0.05 0.05 0.9 0.9]);
hold on
%[c, h] = 
C = log10(reshape(1./testYVar, size(X1)));
C = C - min(min(C));
C = C/max(max(C));
C = round(C*63);
image(x1, x2, C);
for i = 1:length(labelInfo)
  labelInfo(i).mean = mean(X(labelInfo(i).indices, :));
  labelInfo(i).cov = cov(X(labelInfo(i).indices, :));
  text(labelInfo(i).mean(1), labelInfo(i).mean(2), labelInfo(i).text, ...
       'color', [0 0 1], 'fontweight', 'bold'); 
end
visualiseInfo.currentModel = 1;
visualiseInfo.labelInfo = labelInfo;
%image(X1, X2, log10(reshape(1./testYVar, size(X1))));%, 128); 
%shading flat
colormap gray;
%colorbar
gplvmtwoDPlot(X, YLbls, symbol);
visualiseInfo.latentHandle = line(labelInfo(1).mean(1), labelInfo(1).mean(2), 'markersize', 20, 'color', ...
                                  [0 0 0], 'marker', '.', 'visible', ...
                                  'on', 'erasemode', 'xor');
visualiseInfo.clicked = 0;

%dataSet(1) = plot(X(:, 1), X(:, 2), 'r.')
%set(visualiseInfo.dataSet(1), 'MarkerSize', 10)
%hold on

% Set up the X limits and Y limits of the main plot
xLim = [min(X(:, 1)) max(X(:, 1))];
xSpan = xLim(2) - xLim(1);
xLim(1) = xLim(1) - 0.05*xSpan;
xLim(2) = xLim(2) + 0.05*xSpan;
xSpan = xLim(2) - xLim(1);

yLim = [min(X(:, 2)) max(X(:, 2))];
ySpan = yLim(2) - yLim(1);
yLim(1) = yLim(1) - 0.05*ySpan;
yLim(2) = yLim(2) + 0.05*ySpan;
ySpan = yLim(2) - yLim(1);

set(visualiseInfo.plotAxes, 'XLim', xLim)
set(visualiseInfo.plotAxes, 'YLim', yLim)
visualiseInfo.digitAxes = [];
visualiseInfo.digitIndex = [];

% Set the callback function
set(gcf, 'WindowButtonMotionFcn', 'classVisualise(''move'')')
set(gcf, 'WindowButtonDownFcn', 'classVisualise(''click'')')
set(gcf, 'menubar', 'none')

figure(2)
clf
imageAxesa =subplot(1, 1, 1);
set(gcf, 'menubar', 'none')
visData = zeros(1,size(Y, 2));
visData(1) = min(min(Y));
visData(end) = max(max(Y));
visData = Y(1, :);
visHandle = feval(visualiseFunction, visData+meanData, varargin{:});

% Create radio buttons.
PATCHINFO.indicatorPoint = line(0, 0, ...
                                'marker', '.', ...
                                'markersize', 20, ...
                                'visible', 'off');

PATCHINFO.sigmaSlider = uicontrol('style', 'slider', ...
                                  'String', 'Rate In', ...
                                  'units', 'normalized', ...
                                  'position', [0.1 0.05 0.58 0.025], ...
                                  'Max', 0, 'Min', -log10(theta(end)), ...
                                  'SliderStep', [0.01 1], ...
                                  'Callback', ...
                                  'facePatchCallback(''sigmaChange'')', ...
                                  'value', -log10(theta(end)));
PATCHINFO.sigmaLabel = uicontrol('style', 'text', ...
                                 'String', ['Variance:' num2str(1/theta(end))] , ...
                                 'units', 'normalized', ...
                                 'position', [0.1 0.025 0.58 0.025]);


radioHeight = 0.05;
currentBottom = 0.5;
numLabels = length(visualiseInfo.labelInfo);
for i = 1:numLabels
  currentBottom = currentBottom - radioHeight;
  labelRadioPos{i} = [0.8 currentBottom 0.2 radioHeight];
end

% Create Radio buttons



for i = 1:numLabels
  PATCHINFO.labelRadio(i) = ...
      uicontrol('Style', 'radiobutton', ...
		'String', visualiseInfo.labelInfo(i).text, ...
		'units', 'normalized', ...
		'position', labelRadioPos{i}, ...
		'Callback', ['facePatchCallback(''radioClick'', ' ...
		    num2str(i) ')']);
end
set(PATCHINFO.labelRadio(1), 'value', 1);
%set(visHandle, 'erasemode', 'xor')
%colorMap gray
%set(imageAxesa, 'visible', 'off')

%imageAxesa = axes('position', [0.95 0.05 0.05 0.05]);
%visualiseInfo.visHandle = feval(visualiseFunction, Y(1, :), varargin{:});
%colorMap gray
%set(imageAxesa, 'visible', 'off')

% Pass the data to visualiseInfo
visualiseInfo.X = X(activeSet, :);
visualiseInfo.Y = Y(activeSet, :);
visualiseInfo.A = Y'*invK;
visualiseInfo.theta = theta;
visualiseInfo.invSigma= invK;
visualiseInfo.meanData = meanData;
visualiseInfo.varargin = varargin;
visualiseInfo.visualiseModify = visualiseModify;
visualiseInfo.visHandle = visHandle;
hold off




function returnVal = gplvmtwoDPlot(X, label, symbol)

% GPLVMTWODPLOT Helper function for plotting the labels in 2-D.

returnVal = [];

if ~isempty(label)
  for i = 1:size(X, 1)
    labelNo = find(label(i, :));
    try 
      returnVal = [returnVal; plot(X(i, 1), X(i, 2), [symbol{labelNo} '-'])];
    catch
      if strcmp(lasterr, 'Index exceeds matrix dimensions.')
	error(['Only ' num2str(length(symbol)) ' labels supported (it''s easy to add more!)'])
      end
    end
  end
else
  returnVal = plot(X(:, 1), X(:, 2), 'rx-');
end