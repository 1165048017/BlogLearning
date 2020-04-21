function xyzModify(handle, xyzChannels, skel)

% XYZMODIFY Update visualisation of skeleton data.
% FORMAT
% DESC updates a skeleton representation in a 3-D plot.
% ARG handle : a vector of handles to the structure to be updated.
% ARG channels : the channels to update the skeleton with.
% ARG skel : the skeleton structure.
%
% SEEALSO : skelVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006
%
% MODIFICATIONS : Alfredo A. Kalaitzis, 2012

% MOCAP

% if nargin<4
%   padding = 0;
% end
% channels = [channels zeros(1, padding)];
% vals = skel2xyz(skel, channels);

connect = skelConnectionMatrix(skel);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);


set(handle(1), 'Xdata', xyzChannels(:, 1), 'Ydata', xyzChannels(:, 3), 'Zdata', ...
                 xyzChannels(:, 2));
%/~
%set(handle(1), 'visible', 'on')
%~/
  
for i = 1:length(indices)
  set(handle(i+1), 'Xdata', [xyzChannels(I(i), 1) xyzChannels(J(i), 1)], ...
            'Ydata', [xyzChannels(I(i), 3) xyzChannels(J(i), 3)], ...
            'Zdata', [xyzChannels(I(i), 2) xyzChannels(J(i), 2)]);
end


function [vals, connect] = wrapAround(vals, lim, connect)


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
