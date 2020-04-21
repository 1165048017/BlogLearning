function rotMat = rotationMatrixGradient(xangle, yangle, zangle, order, gadrientRespect);

% ROTATIONMATRIXGRADIENT Compute the gradient rotation matrix in respect with a certain direction.
%
%	Description:
%
%	ROTATIONMATRIXGRADIENT(xangle, yangle, zangle, order, gadrientRespect) is a helper function
%	for computing the gradient rotation matrix for a given set of angles in a
%	given order in respect with the gradient direction.
%	 Arguments:
%	  XANGLE - rotation for x-axis.
%	  YANGLE - rotation for y-axis.
%	  ZANGLE - rotation for z-axis.
%	  ORDER - the order for the rotations.
%     GRADIENTRESPECT - the direction of the gradient



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

% see http://en.wikipedia.org/wiki/Rotation_matrix for
% additional info.

  rotMat = eye(3);
  for i = 1:length(order)
    switch order(i)
     case 'x'
         if (gadrientRespect == 'x')
             rotMat = [0 0 0
                0  -s1 c1
                0 -c1 -s1]*rotMat;
             
         else
      rotMat = [1 0 0
                0  c1 s1
                0 -s1 c1]*rotMat;
         end
     case 'y'
         if (gadrientRespect == 'y')
             rotMat = [-s2 0 -c2
                       0 0 0
                       c2 0 -s2]*rotMat;
             
         else
      rotMat = [c2 0 -s2
                0 1 0
                s2 0 c2]*rotMat;
         end
     case 'z' 
         if (gadrientRespect == 'z')
      rotMat = [-s3 c3 0
                -c3 -s3 0
                0 0 0]*rotMat;       
             
         else
      rotMat = [c3 s3 0
                -s3 c3 0
                0 0 1]*rotMat;
         end
      
    end
  
end
