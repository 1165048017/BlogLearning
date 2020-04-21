function [bvhStruct, channels, frameLength, velocityIndices] = bvhLoadData(dataSet, velocityIndices)

% BVHLOADDATA Load a motion capture data set.

if nargin < 2
  % By default consider x and y motion as velocity 
  velocityIndices = [1 3 6];
end
dataDir = mocapDataDir;
switch dataSet
 otherwise
  % assume the data set is a bvh filename.
  fileName = [mocapDataDir dataSet '.bvh'];
  
  if exist(fileName) == 2
    [bvhStruct, channels, frameLength] = bvhReadFile(fileName);
    % Convert specified channels into velocities
    for i = 2:size(channels, 1)
      for j = velocityIndices
        channels(i-1, j) = channels(i, j) - channels(i-1, j);
      end
    end
  else
    error([fileName ' does not exist.'])
  end  
end
