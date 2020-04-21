function plotJointConnections(frame_x, frame_y, frame_z, connection)

noJoints = length(connection(1,:));
twoPoints = zeros(2, 3);
somethingPlotted = 0;

for i = 1:noJoints;
    for j = 1:noJoints;
        if connection(i,j) == 1            
            twoPoints(1,1) = frame_x(1,i);
            twoPoints(2,1) = frame_x(1,j);
            twoPoints(1,2) = frame_z(1,i);
            twoPoints(2,2) = frame_z(1,j);
            twoPoints(1,3) = frame_y(1,i);
            twoPoints(2,3) = frame_y(1,j);
            plot3(twoPoints(:,1), twoPoints(:,2), twoPoints(:,3), '-o', 'LineWidth', 2);
            
            if somethingPlotted == 0
                hold on;
                somethingPlotted = 1;
            end
        end
    end
end

hold off;
