function  mocapData = mocapLoadData(dataSet, velocity)

% MOCAPLOADDATA Load a motion capture data set.

dataDir = mocapDataDir;
if nargin < 2
  velocity = 1;
end
switch dataSet
 otherwise
  % assume the data set is a bvh filename.
  fileName = [mocapDataDir dataSet '.bvh'];

  if exist(fileName) == 7
    [bvhStruct, channels, frameLength] = bvhReadFile(fileName);
    if velocity
      % Convert root's channels into velocities
      rootIndices = 1;
      for i = 2:size(channels, 1)
        for j = rootIndices
          for k = bvhStruct(j).posInd
            channels(i-1, k) = channels(i, k) - channels(i-1, k);
          end
          for k = bvhStruct(j).rotInd
            channels(i-1, k) = channels(i, k) - channels(i-1, k);
          end
        end
      end
    end
  end
end
