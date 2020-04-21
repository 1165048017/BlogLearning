function rotMat = rotationMatrixGrad(xangle, yangle, zangle, order);

% ROTATIONMATRIX Compute the rotation matrix for an angle in each direction.

if nargin < 4
  order = 'zxy';
end
if isempty(order)
  order = 'zxy';
end
% Here we assume we rotate z, then x then y.
c1 = cos(xangle); % The x angle
c2 = cos(yangle); % The y angle
c3 = cos(zangle); % the z angle
s1 = sin(xangle);
s2 = sin(yangle);
s3 = sin(zangle);

% see http://mathworld.wolfram.com/RotationMatrix.html for
% additional info.

switch order
 case 'zxy'
  rotMat = [c2*c3-s1*s2*s3 c2*s3+s1*s2*c3 -s2*c1
            -c1*s3 c1*c3 s1
            s2*c3+c2*s1*s3 s2*s3-c2*s1*c3 c2*c1];
 otherwise
  rotMat = eye(3);
  for i = 1:length(order)
    switch order(i)
     case 'x'
      rotMat = [1 0 0
                0  c1 s1
                0 -s1 c1]*rotMat;
     case 'y'
      rotMat = [c2 0 -s2
                0 1 0
                s2 0 c2]*rotMat;
     case 'z' 
      rotMat = [c3 s3 0
                -s3 c3 0
                0 0 1]*rotMat;
      
    end
  end
  
end
