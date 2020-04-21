function bvhPlayFile(fileName)

% BVHPLAYFILE Play motion capture data from a bvh file.
% FORMAT
% DESC plays motion capture data by reading in a bvh file from disk.
% ARG fileName : the name of the file to read in, in bvh format.
%
% COPYRIGHT : Neil D. Lawrence, 2005
%
% SEEALSO : acclaimPlayFile, bvhReadFile, skelPlayData

% MOCAP

[skel, channels, frameLength] = bvhReadFile(fileName);
skelPlayData(skel, channels, frameLength);
