function handle = xyzankurModify(handle,pos, varargin)

% XYZANKURMODIFY  Helper function for modifying the point cloud from Agarwal and Triggs data.
% FORMAT
% DESC modifies the stick figure associated with a set of x,y,z points for
% the Agarwal and Triggs silhouette data.
% ARG handle : graphics handles to modify.
% ARG joint : the positions of the joints.
% RETURN handle : modified graphics handles.
%
% SEEALSO : xyzankurDraw, xyzankurVisualise
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


joint = xyzankur2joint(pos);

if(iscell(handle))
  for(i = 1:1:length(handle))
    xyzankurDraw(joint,handle{i}); 
  end
else
  xyzankurDraw(joint,handle);
end
