function skelWriteAvi(skelStruct, channels, frameLength, videoname)

% SKELWRITEAVI Writes data to an AVI file.
% FORMAT 
% DESC writes channels from a motion capture skeleton and channels
% to an avi file.
% ARG skel : the skeleton for the motion.
% ARG channels : the channels for the motion.
% ARG frameLength : the framelength for the motion.
% ARG filename: the filenme to use
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% COPYRIGHT : Redouane Lguensat, 2016
%
% SEEALSO : skelPlayData

% MOCAP

if nargin < 4
  videoname='animation.avi';
  if nargin < 3
    frameLength = 1/120;
  end 
end
clf

handle = skelVisualise(channels(1, :), skelStruct);


% Get the limits of the motion.
xlim = get(gca, 'xlim');
minY1 = xlim(1);
maxY1 = xlim(2);
ylim = get(gca, 'ylim');
minY3 = ylim(1);
maxY3 = ylim(2);
zlim = get(gca, 'zlim');
minY2 = zlim(1);
maxY2 = zlim(2);
for i = 1:size(channels, 1)
  Y = skel2xyz(skelStruct, channels(i, :));
  minY1 = min([Y(:, 1); minY1]);
  minY2 = min([Y(:, 2); minY2]);
  minY3 = min([Y(:, 3); minY3]);
  maxY1 = max([Y(:, 1); maxY1]);
  maxY2 = max([Y(:, 2); maxY2]);
  maxY3 = max([Y(:, 3); maxY3]);
end
xlim = [minY1 maxY1];
ylim = [minY3 maxY3];
zlim = [minY2 maxY2];
set(gca, 'xlim', xlim, ...
         'ylim', ylim, ...
         'zlim', zlim);


% Play the motion
vidObj = VideoWriter(videoname);
open(vidObj);
for j = 1:size(channels, 1)
  pause(frameLength)
  skelModify(handle, channels(j, :), skelStruct);
  writeVideo(vidObj,getframe(gcf));
end
close(vidObj);
