function handle = faceVisualise(vals, connect)

% FACEVISUALISE For updateing a face representation of 3-D data.

numMark = size(vals, 2)/3;
valsx = vals(1, 1:numMark);
valsy = vals(1, numMark+1:2*numMark);
valsz = vals(1, 2*numMark+1:3*numMark);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
%handle(1) = plot3(valsx, valsy, valsz, '.');
handle(1) = plot(valsx, valsz, '.');
set(handle(1), 'markersize', 12);
set(handle(1), 'visible', 'off')
hold on
grid on
for i = 1:length(indices)
  handle(i+1) = line([valsx(I(i)) valsx(J(i))], ...
              [valsz(I(i)) valsz(J(i))]); ...
  %              [valsz(I(i)) valsz(J(i))]);
  set(handle(i+1), 'linewidth', 2);
%  set(handle(i+1), 'visible', 'off')
end
axis equal
%set(gca, 'zlim', [-2 2])
set(gca, 'ylim', [-4 4])
set(gca, 'xlim', [-2 2])
xlabel('x')
ylabel('z')
zlabel('y')
%set(gca, 'cameraposition', [-1.3954  -91.5992   46.0000])
