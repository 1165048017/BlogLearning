function skelModify(handle, channels, skel, padding, zeroIndices)

% SKELMODIFY Update visualisation of skeleton data.
% FORMAT
% DESC updates a skeleton representation in a 3-D plot.
% ARG handle : a vector of handles to the structure to be updated.
% ARG channels : the channels to update the skeleton with.
% ARG skel : the skeleton structure.
%
% SEEALSO : skelVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006

% MOCAP

if nargin<4
  padding = 0;
end
channels = [channels zeros(1, padding)];
vals = skel2xyz(skel, channels);
connect = skelConnectionMatrix(skel);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);


set(handle(1), 'Xdata', vals(:, 1), 'Ydata', vals(:, 3), 'Zdata', ...
                 vals(:, 2));
%/~
%set(handle(1), 'visible', 'on')
%~/
  
for i = 1:length(indices)
  set(handle(i+1), 'Xdata', [vals(I(i), 1) vals(J(i), 1)], ...
            'Ydata', [vals(I(i), 3) vals(J(i), 3)], ...
            'Zdata', [vals(I(i), 2) vals(J(i), 2)]);
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
