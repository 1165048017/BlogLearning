function handle = xyzpoppeVisualise(pos,fid)

% XYZPOPPEVISUALISE Draw the Poppe figure return the graphics handle.
% FORMAT
% DESC draws the stick figure from the Poppe silhouette
% data. 
% ARG pos : the positions of the joints.
% ARG v : the view point for the figure (defaults to standard 3D view). 
% RETURN handle : the graphics handle of the drawn object.
%
% SEEALSO : xyzpoppeDraw, xyzpoppeModify
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP

if(nargin<2);
  fid = 1;
end

% Convert positions for plotting.
joint = xyzpoppe2joint(pos);
handle = xyzpoppeDraw(joint);
axis equal
view(3);

xlabel('x');
ylabel('z');
zlabel('y');
axis on

return;
