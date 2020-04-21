function xyz = bvh2xyz(skel, channels, noOffset)

% BVH2XYZ Compute XYZ values given structure and channels.
% FORMAT
% DESC Computes X, Y, Z coordinates given a BVH skeleton structure and
% an associated set of channels.
% ARG skel : a skeleton for the bvh file.
% ARG channels : the channels for the bvh file.
% ARG noOffset : don't add the offset in.
% RETURN xyz : the point cloud positions for the skeleton.
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2008, 2012
%
% SEEALSO : acclaim2xyz, skel2xyz

% MOCAP

if nargin< 3
  noOffset = false;
end
for i = 1:length(skel.tree)  
  if ~isempty(skel.tree(i).posInd)
    xpos = channels(skel.tree(i).posInd(1));
    ypos = channels(skel.tree(i).posInd(2));
    zpos = channels(skel.tree(i).posInd(3));
  else
    xpos = 0;
    ypos = 0;
    zpos = 0;
  end
  xyzStruct(i) = struct('rotation', [], 'xyz', []); 
  if nargin < 2 | isempty(skel.tree(i).rotInd)
    xangle = 0;
    yangle = 0;
    zangle = 0;
  else
    xangle = deg2rad(channels(skel.tree(i).rotInd(1)));
    yangle = deg2rad(channels(skel.tree(i).rotInd(2)));
    zangle = deg2rad(channels(skel.tree(i).rotInd(3)));
  end
  thisRotation = rotationMatrix(xangle, yangle, zangle, skel.tree(i).order);
  thisPosition = [xpos ypos zpos];
  if ~skel.tree(i).parent
      xyzStruct(i).rotation = thisRotation;
      xyzStruct(i).xyz = thisPosition + skel.tree(i).offset;
  else
      if ~noOffset
          thisPosition = skel.tree(i).offset + thisPosition;
      end
      xyzStruct(i).xyz = ...
          thisPosition*xyzStruct(skel.tree(i).parent).rotation ...
          + xyzStruct(skel.tree(i).parent).xyz;
      xyzStruct(i).rotation = thisRotation*xyzStruct(skel.tree(i).parent).rotation;
    
  end
end
xyz = reshape([xyzStruct(:).xyz], 3, length(skel.tree))';



