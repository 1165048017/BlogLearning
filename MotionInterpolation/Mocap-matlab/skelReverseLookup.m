function index = skelReverseLookup(skel, jointName)

% SKELREVERSELOOKUP Return the number associated with the joint name.
% FORMAT
% DESC returns the number associated with a particular joint name in a
% given skeleton.
% ARG skel : the skeleton to look up.
% ARG jointName : the joint name to look up.
% RETURN index : the index of the joint name in the skeleton.
%
% COPYRIGHT : Neil D. Lawrence, 2006
%

% MOCAP

for i=1:length(skel.tree)
  if strcmp(skel.tree(i).name, jointName)
    index = i;
    return
  end
end

error('Reverse look up of name failed.')
