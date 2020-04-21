function handle = xyzhumanevaModify(handle,pos)

% XYZHUMANEVAMODIFY
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


joint = xyzhumaneva2joint(pos);

if(iscell(handle))
  for(i = 1:1:length(handle))
    xyzhumanevaDraw(joint,handle{i});
  end
else
  xyzhumanevaDraw(joint,handle);
end

return
