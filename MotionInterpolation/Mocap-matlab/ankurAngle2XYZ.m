function X = ankurAngle2XYZ(X)

if(size(X,2)~=54)
  error('Wrong Dimensionality of Data');
end

matrix_to_bvh(X','tmp.bvh');
X = bvh_to_3dmatrix('tmp.bvh');

% clean up
system('rm tmp.bvh');

return;