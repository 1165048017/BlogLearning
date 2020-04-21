function handle = xyzpoppeModify(handle,pos)

% XYZPOPPEMODIFY
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


joint = xyzpoppe2joint(pos);

if(iscell(handle))
  for(i = 1:1:length(handle))
    xyzpoppeDraw(joint,handle{i});
  end
else
  xyzpoppeDraw(joint,handle);
end

return
