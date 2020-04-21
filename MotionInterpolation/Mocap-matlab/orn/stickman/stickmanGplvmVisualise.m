function handle = stickmanGplvmVisualise(vals, connection)

numPoints = size(vals, 2) / 3;

frame_x = vals(1:numPoints);
frame_y = vals(numPoints+1:2*numPoints);
frame_z = vals(2*numPoints+1:3*numPoints);

plotJointConnections(frame_x, frame_y, frame_z, connection);
set(gca, 'DataAspectRatio', [1 1 1]);
grid on;

% handle = @plotJointConnections;

handle = plot3(frame_x, frame_y, frame_z, 'o');
