function xyzpoppeAnim(X, fps)

% XYZPOPPEANIM Animate point cloud of stick man from Poppe dataset.
% FORMAT
% DESC animates a matrix of x,y,z point clound positions representing the
% motion of the figure used to generate the silhouttes for Poppe
% Silhouette data
% ARG y : the data to animate.
% ARG fps : the number of frames per second to animate (defaults to 24).
%
% SEEALSO : xyzpoppeVisualise, xyzpoppeModify
%  
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP
  
if(nargin<3)
  fps = 24;
  if(nargin<2)
    fid = 1;
    if(nargin<1)
      error('Too few arguments');
    end
  end
end

for(i = 1:1:size(X,1))
  if(i==1)
    handle = xyzpoppeVisualise(X(i,:),1);
  else
    xyzpoppeModify(handle,X(i,:));
  end
  pause(1/fps);
end
