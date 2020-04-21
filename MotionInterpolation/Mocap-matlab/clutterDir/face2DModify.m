function face2DModify(handle, vals, patches)

% FACE2DMODIFY Helper code for visualisation of a face.

global PATCHINFO
numMark = size(vals, 2)/3;
valsx = vals(1, 1:numMark);
valsy = vals(1, numMark+1:2*numMark);
valsz = vals(1, 2*numMark+1:3*numMark);
PATCHINFO.points = [valsx' valsy' valsz'];

set(handle(1), 'Xdata', valsx, 'Ydata', valsz);
for i = 1:length(patches)
  X = zeros(1, length(patches(i).index));
%  Y = zeros(1, length(patches(i).index));
  Z = zeros(1, length(patches(i).index));
  for j = 1:length(X)
    X(j) = valsx(patches(i).index(j));
%    Y(j) = valsy(patches(i).index(j));
    Z(j) = valsz(patches(i).index(j));
  end
  
  set(handle(i+1), 'Xdata', X, ...
            'Ydata', Z);
end
drawnow