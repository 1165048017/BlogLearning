function StickManPlot(frame_x, frame_z, frame_y, connection)

plot3(frame_x, frame_z, frame_y, 'o', 'LineWidth', 2);

noJoints = length(connection(1,:));
twoPoints = zeros(2, 3);

hold on;

for i = 1:noJoints;
    for j = 1:noJoints;
        if connection(i,j) == 1
            twoPoints(1,1) = frame_x(1,i);
            twoPoints(2,1) = frame_x(1,j);
            twoPoints(1,2) = frame_z(1,i);
            twoPoints(2,2) = frame_z(1,j);
            twoPoints(1,3) = frame_y(1,i);
            twoPoints(2,3) = frame_y(1,j);
            plot3(twoPoints(:,1), twoPoints(:,2), twoPoints(:,3), 'LineWidth', 2);
        end
    end
end

hold off;

set(gca, 'XLim', [-100 100]);
set(gca, 'YLim', [-100 100]);
set(gca, 'ZLim', [-100 100]);
campos([20 80 60]);
camtarget([0 0 0]);
set(gca, 'DataAspectRatio', [1 1 1]);
grid on;
