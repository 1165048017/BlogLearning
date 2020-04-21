function handle = xyzVisualise(xyzChannels, skel, shadow)

% XYZVISUALISE For drawing an xyz representation of 3-D data.
% FORMAT
% DESC draws a skeleton representation in a 3-D plot.
% ARG xyzChannels : the 3-D coordinate channels to update the skeleton with.
% ARG skel : the skeleton structure.
% RETURN handle : a vector of handles to the plotted structure.
%
% SEEALSO : skelVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006
%
% MODIFICATIONS : Alfredo A. Kalaitzis, 2012

% MOCAP

if isstruct(skel) == 1
    connect = skelConnectionMatrix(skel);   % Extract connection matrix.
else
    connect = skel;
end

indices = find(connect);
handle = zeros(length(indices),1);
[I, J] = ind2sub(size(connect), indices);
handle(1) = plot3(xyzChannels(:, 1), xyzChannels(:, 3), xyzChannels(:, 2), '.');
axis ij % make sure the left is on the left.
set(handle(1), 'markersize', 20);
%/~
%set(handle(1), 'visible', 'off')
%~/
hold on
grid on
colorRange = unique(connect);
cmap = hot(length(colorRange));
minZ = min(xyzChannels(:, 2));
for i = 1:length(indices)
    handle(i+1) = line( [xyzChannels(I(i), 1) xyzChannels(J(i), 1)], ...
                        [xyzChannels(I(i), 3) xyzChannels(J(i), 3)], ...
                        [xyzChannels(I(i), 2) xyzChannels(J(i), 2)] );
    if nargin > 2 && shadow == true
        line( [xyzChannels(I(i), 1) xyzChannels(J(i), 1)], ...  % Just a shadow effect.
              [xyzChannels(I(i), 3) xyzChannels(J(i), 3)], ...
              [minZ minZ], 'color', 'k');
    end
    edgeColor = connect(indices(i));
    set(handle(i+1), 'linewidth', 2 + abs(edgeColor), 'color', cmap( colorRange == edgeColor ,:));
end
axis equal
xlabel('x')
ylabel('z')
zlabel('y')
axis on

