function skelPlayDataA(skelStruct, channels, frameLength)

% SKELPLAYDATA Play skel motion capture data.
%
% skelPlayData(skelStruct, channels, frameLength)
%

% Copyright (c) 2006 Neil D. Lawrence
% skelPlayData.m version 1.1
% edited by deaton

if nargin < 3
  frameLength = 1/120;
end

figure(gcf);
clf;

handle = skelVisualise(channels(1, :), skelStruct);
% set(handle,'color','k');
% Get the limits of the motion.
% do so approximately, because this approach is too slow!
xlim = get(gca, 'xlim');
minY1 = xlim(1);
maxY1 = xlim(2);
ylim = get(gca, 'ylim');
minY3 = ylim(1);
maxY3 = ylim(2);
zlim = get(gca, 'zlim');
minY2 = zlim(1);
maxY2 = zlim(2);
frames=size(channels,1);
step=1;
for i = 1:step:frames
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
% skip every second frame -- 120Hz is too much data to play @ framerate (in
% matlab, at least)
m=size(channels, 1);
if(m>=30)
    decimateBy = 2;
else
    decimateBy = 1;
end
isFinal=0;
sH=annotation(gcf,'textbox',[0.5714 0.8466 0.1607 0.07143]);
% sH = text(xlim(2), zlim(1), ylim(2), sprintf('%i/%i', 1, size(channels,1)));
for j = [1:decimateBy:m frames]
   if frameLength>0, pause(frameLength); end
   if(j==1)
       isFinal=-1;%第一帧
   else
       if(j==size(channels, 1))
           isFinal=1;%最后一帧
       else isFinal=0; %中间帧
       end
   end
   skelModifyA(handle, channels(j, :), skelStruct,0,isFinal);
   
   set( sH, 'String', sprintf('%i/%i',j,frames) );
   drawnow();
  
end
