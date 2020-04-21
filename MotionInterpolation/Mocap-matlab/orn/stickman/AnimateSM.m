
noCoordinates = length(points(1,:));
noFrames = length(points(:,1));
noPoints = noCoordinates / 3;

points_x = zeros(noFrames, noPoints);
points_y = zeros(noFrames, noPoints);
points_z = zeros(noFrames, noPoints);

line = zeros(1, noCoordinates);

frameNo = 1;

while( frameNo <= noFrames )
    line = points(frameNo,:);
    
    points_x(frameNo,:) = line(1:noPoints);
    points_y(frameNo,:) = line(noPoints+1:2*noPoints);
    points_z(frameNo,:) = line(2*noPoints+1:3*noPoints);
    
    frameNo = frameNo + 1;
end

% Animate
frame_x = zeros(1, noPoints);
frame_y = zeros(1, noPoints);
frame_z = zeros(1, noPoints);

t = timer('TimerFcn','StickManPlot(frame_x,frame_z,frame_y,connection)', 'StartDelay', 0.01);

frameNo = 1;

while( frameNo <= noFrames )
    frame_x = points_x(frameNo, :);
    frame_y = points_y(frameNo, :);
    frame_z = points_z(frameNo, :);
    
    start(t);
    frameNo = frameNo + 1;
    wait(t);
end

delete(t);