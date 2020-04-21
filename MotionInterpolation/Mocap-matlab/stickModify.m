function stickModify(handle, values, connect)

% STICKMODIFY Helper code for visualisation of a stick man.
% FORMAT
% DESC updates a stick man representation in a 3-D plot.
% ARG handle : a vector of handles to the structure to be updated.
% ARG vals : the x,y,z channels to update the skeleton with.
% ARG connect : the connectivity of the skeleton.
%
% SEEALSO : stickVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006


% MOCAP

vals = reshape(values, size(values, 2)/3, 3);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
set(handle(1), 'Xdata', vals(:, 1), 'Ydata', vals(:, 2), 'Zdata', ...
                 vals(:, 3));
%set(handle(1), 'visible', 'off')


for i = 1:length(indices)
  set(handle(i+1), 'Xdata', [vals(I(i), 1) vals(J(i), 1)], ...
            'Ydata', [vals(I(i), 2) vals(J(i), 2)], ...
            'Zdata', [vals(I(i), 3) vals(J(i), 3)]);
end
