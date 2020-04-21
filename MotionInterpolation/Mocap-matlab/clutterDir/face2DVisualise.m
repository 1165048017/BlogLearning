function handle = face2DVisualise(vals, patches)

% FACEPATCHVISUALISE For updateing a face representation of 3-D data.

global PATCHINFO


PATCHINFO.moveMode = 0;
numMark = size(vals, 2)/3;
valsx = vals(1, 1:numMark);
valsy = vals(1, numMark+1:2*numMark);
valsz = vals(1, 2*numMark+1:3*numMark);
PATCHINFO.points = [valsx' valsy' valsz'];

handle(1) = plot(valsx, valsz, '.');
set(handle(1), 'markersize', 12);
set(handle(1), 'visible', 'off')
hold on
grid on
for i = 1:length(patches)
  X = zeros(1, length(patches(i).index));
%  Y = zeros(1, length(patches(i).index));
  Z = zeros(1, length(patches(i).index));
  for j = 1:length(X)
    X(j) = valsx(patches(i).index(j));
%    Y(j) = valsy(patches(i).index(j));
    Z(j) = valsz(patches(i).index(j));
  end
  handle(i+1) = patch(X, Z, patches(i).colour);
%  set(handle(i+1), 'linewidth', 2);
%  set(handle(i+1), 'visible', 'off')
end
axis equal
%set(gca, 'zlim', [-2 2])
%set(gca, 'ylim', [-2 2])
%set(gca, 'xlim', [-2 2])
xlabel('x')
ylabel('z')
zlabel('y')
%set(gca, 'cameraposition', [0  40 0])
axis off
set(gcf, 'WindowButtonMotionFcn', 'facePatchCallback(''move'')')
set(gcf, 'WindowButtonDownFcn', 'facePatchCallback(''click'')')
PATCHINFO.drawFigure = gcf;
PATCHINFO.plotAxes = gca;
PATCHINFO.indicatorPoint = line(0, 0, ...
                                'marker', '.', ...
                                'markersize', 20, ...
                                'visible', 'off');

PATCHINFO.sigmaSlider = uicontrol('style', 'slider', ...
                                  'String', 'Rate In', ...
                                  'units', 'normalized', ...
                                  'position', [0.1 0.05 0.58 0.025], ...
                                  'Max', 5, 'Min', 0, ...
                                  'SliderStep', [0.01 1], ...
                                  'Callback', 'facePatchCallback(''sigmaChange'')');
PATCHINFO.sigmaLabel = uicontrol('style', 'text', 'String', 'Beta:', 'units', 'normalized', 'position', ...
                                 [0.1 0.025 0.58 0.025]);
