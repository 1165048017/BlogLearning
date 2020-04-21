function vectorModify(handle, values, names, connect)

% VECTORMODIFY Helper code for visualisation of vectorial data.

vals = reshape(values, size(values, 2)/3, 3);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
set(handle(1), 'Xdata', vals(:, 1), 'Ydata', vals(:, 2), 'Zdata', ...
                 vals(:, 3));


for i = 1:length(indices)
  set(handle(i+1), 'Xdata', [vals(I(i), 1) vals(J(i), 1)], ...
            'Ydata', [vals(I(i), 2) vals(J(i), 2)], ...
            'Zdata', [vals(I(i), 3) vals(J(i), 3)]);
end
