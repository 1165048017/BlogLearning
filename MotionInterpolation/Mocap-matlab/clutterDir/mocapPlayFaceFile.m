% MOCAPPLAYFACEFILE Play a face file of motion capture data. 

% Load patches

% connections = mocapFaceConnections('../data/manuel/connections.txt');
% connections(:, 73:end) = [];
% connections(73:end, :) = [];
patches = mocapFacePatches('../data/manuel/patches.txt');
for i = 1:4
  patches(i).colour = zeros(size(patches(i).colour));
end
indToDel = [];
for i = 1:length(patches)
  if any(patches(i).index > 72)
    indToDel = [indToDel i];
  end
end
load ../data/2_2.mat
lastMarker = 72*3+1;
points{1} = vals(:, 2:3:lastMarker);
points{2} = vals(:, 3:3:lastMarker);
points{3} = vals(:, 4:3:lastMarker);
for i = 1:3
  vals = points{i}(:, 3) + points{i}(:, 50) + points{i}(:, 60);
  vals = vals/3;
  for j = 1:size(points{i}, 2);
    points{i}(:, j) = points{i}(:, j) - vals;
  end
end
patches(indToDel) = [];
Y = [points{1} points{3} points{2}]*4;

pause
fprintf('Press any key.\n');
mocapPlayFace(Y(1:5:end, :), patches);
