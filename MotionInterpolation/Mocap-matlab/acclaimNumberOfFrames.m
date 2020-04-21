function nFrames = acclaimNumberOfFrames(fileName)

% ACCLAIMNUMBEROFFRAMES Extract the number of frames.
% FORMAT
% DESC counts the total number of frames from an acclaim motion capture
% file.
% ARG fileName : the file name to load in.
% RETURN nFrames : the total number of frames in the file.
%
% COPYRIGHT : Alfredo A. Kalaitzis, 2012
%
% SEEALSO :

% MOCAP

fid = fopen(fileName, 'rt');

% Assumes the number of lines in each frame is fixed.
a = cell(textscan(fid, '%s'));
a = a{1};
nFrames = str2double(a{end-91}); % 91 strings from eof to last frame #

fclose(fid);
