function stickmanGplvmModify(handle, vals, connection)

numPoints = size(vals, 2) / 3;

frame_x = vals(1:numPoints);
frame_y = vals(numPoints+1:2*numPoints);
frame_z = vals(2*numPoints+1:3*numPoints);

figure(2)

plotJointConnections(frame_x, frame_y, frame_z, connection);
% feval(handle, frame_x, frame_y, frame_z, connection);

set(gca, 'DataAspectRatio', [1 1 1]);
grid on;

figure(1)