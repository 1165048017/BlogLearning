function handle = vectorVisualise(vals, names, connect)

% VECTORVISUALISE  Helper code for plotting a vector during 2-D visualisation.Plot the oil data

vals = reshape(vals, size(vals, 2)/3, 3);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
handle(1) = plot3(vals(:, 1), vals(:, 2), vals(:, 3), 'ro');
hold on
for i = 1:length(indices)
  handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)], ...
              [vals(I(i), 2) vals(J(i), 2)], ...
              [vals(I(i), 3) vals(J(i), 3)]);
end
%for i = 1:size(vals, 1)
%  handle = [handle text(vals(i, 1), vals(i, 2), vals(i, 3), names{i})];
%end
