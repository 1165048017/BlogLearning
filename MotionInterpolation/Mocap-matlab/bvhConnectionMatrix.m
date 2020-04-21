function connection = bvhConnectionMatrix(skel);

% BVHCONNECTIONMATRIX Compute the connection matrix for the structure.
% FORMAT
% DESC computes the connection matrix for the structure. Returns a matrix
% which has zeros at all entries except those that are connected in the
% skeleton.
% ARG skel : the skeleton for which the connectivity is required.
% RETURN connection : connectivity matrix.
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006
%
% SEEALSO : skelConnectionMatrix

% MOCAP

connection = skelConnectionMatrix(skel);

