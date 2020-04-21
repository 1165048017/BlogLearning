function handle = skelVisualise(channels, skel, padding)

% SKELVISUALISE For drawing a skel representation of 3-D data.
% FORMAT
% DESC draws a skeleton representation in a 3-D plot.
% ARG channels : the channels to update the skeleton with.
% ARG skel : the skeleton structure.
% RETURN handle : a vector of handles to the plotted structure.
%
% SEEALSO : skelModify
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006
  
% MOCAP

if nargin<3
  padding = 0;
end
channels = [channels zeros(1, padding)];
vals = skel2xyz(skel, channels);
connect = skelConnectionMatrix(skel);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
handle(1) = plot3(vals(:, 1), vals(:, 3), vals(:, 2), '.');
axis ij % make sure the left is on the left.
set(handle(1), 'markersize', 20);
%/~
%set(handle(1), 'visible', 'off')
%~/
hold on
grid on
for i = 1:length(indices)
  handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)], ...
              [vals(I(i), 3) vals(J(i), 3)], ...
              [vals(I(i), 2) vals(J(i), 2)]);
  set(handle(i+1), 'linewidth', 2);
end
axis equal
xlabel('x')
ylabel('z')
zlabel('y')
axis on
