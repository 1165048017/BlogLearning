function facePatchModify(handle, vals, patches)

% FACEPATCHMODIFY Helper code for visualisation of a face.

numMark = size(vals, 2)/3;
valsx = vals(1, 1:numMark);
valsy = vals(1, numMark+1:2*numMark);
valsz = vals(1, 2*numMark+1:3*numMark);
PATCHINFO.points = [valsx' valsy' valsz'];

set(handle(1), 'Xdata', valsx, 'Ydata', valsy, 'Zdata', ...
                 valsz);
%set(handle(1), 'visible', 'on');
for i = 1:length(patches)
  X = zeros(1, length(patches(i).index));
  Y = zeros(1, length(patches(i).index));
  Z = zeros(1, length(patches(i).index));
  for j = 1:length(X)
    X(j) = valsx(patches(i).index(j));
    Y(j) = valsy(patches(i).index(j));
    Z(j) = valsz(patches(i).index(j));
  end
  
  set(handle(i+1), 'Xdata', X, ...
            'Ydata', Y, ...
            'Zdata', Z);
end
drawnow