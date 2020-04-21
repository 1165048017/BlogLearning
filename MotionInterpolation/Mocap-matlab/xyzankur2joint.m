function joint = xyzankur2joint(pos)

% XYZANKUR2JOINT Converts data to xyz positions for each joint.
% FORMAT
% DESC takes in a vector of values and returns a matrix with points in
% rows and coordinate positions in columns.
% ARG pos : the vector of values.
% ARG joint : the matrix of values with points in rows and x,y,z
% positions in columns.
%
% 
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


joint(:,1) = pos(3:3:end);
joint(:,2) = -pos(1:3:end);
joint(:,3) = -pos(2:3:end);

return
