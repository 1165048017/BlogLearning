%将多帧显示在同一图片上
function skelModifyA(handle, channels, skel, padding,isFinal)
% SKELMODIFY Helper code for visualisation of skel data.
%
% skelModify(handle, channels, skel, padding)
%

% Copyright (c) 2006 Neil D. Lawrence
% skelModify.m version 1.1



if nargin<4
  padding = 0;
end
channels = [channels zeros(1, padding)];
vals = skel2xyz(skel, channels);
connect = skelConnectionMatrix(skel);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);

% handle(1) = plot3(vals(:, 1), vals(:, 3), vals(:, 2), 'k.');  
% set(handle(1), 'Xdata', vals(:, 1), 'Ydata', vals(:, 3), 'Zdata', ...
%                  vals(:, 2));
if (isFinal==1)
    color='r';%最后一帧颜色为红色
else if(isFinal==0)
        color='k';%中间帧为黑色
    else if(isFinal==-1)
            color='b';%首帧为蓝色
        end
    end
end
 
for i = 1:length(indices)
  set(handle(i+1), 'Xdata', [vals(I(i), 1) vals(J(i), 1)], ...
            'Ydata', [vals(I(i), 3) vals(J(i), 3)], ...
            'Zdata', [vals(I(i), 2) vals(J(i), 2)],'color',color);
        handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)], ...
            [vals(I(i), 3) vals(J(i), 3)], ...
            [vals(I(i), 2) vals(J(i), 2)],'color',color); %保持中间帧
end


function [vals, connect] = wrapAround(vals, lim, connect);


quot = lim(2) - lim(1);
vals = rem(vals, quot)+lim(1);
nVals = floor(vals/quot);
for i = 1:size(connect, 1)
  for j = find(connect(i, :))
    if nVals(i) ~= nVals(j)
      connect(i, j) = 0;
    end
  end
end
