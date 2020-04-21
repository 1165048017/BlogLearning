function connection = skelConnectionMatrix(skel);

% SKELCONNECTIONMATRIX Compute the connection matrix for the structure.
% FORMAT
% DESC computes the connection matrix for the structure. Returns a matrix
% which has zeros at all entries except those that are connected in the
% skeleton.
% ARG skel : the skeleton for which the connectivity is required.
% RETURN connection : connectivity matrix.
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : skelVisualise, skelModify
  
% MOCAP

connection = zeros(length(skel.tree));
for i = 1:length(skel.tree);
  for j = 1:length(skel.tree(i).children)    
    connection(i, skel.tree(i).children(j)) = 1;
  end
end

