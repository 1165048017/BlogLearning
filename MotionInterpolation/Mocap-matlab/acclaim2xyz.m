function xyz = acclaim2xyz(skel, channels)

% ACCLAIM2XYZ Compute XYZ values given skeleton structure and channels.
% FORMAT
% DESC Computes X, Y, Z coordinates given an acclaim skeleton
% structure and an associated set of channels.
% ARG skel : a skeleton for the bvh file.
% ARG channels : the channels for the bvh file.
% RETURN xyz : the point cloud positions for the skeleton.
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : skel2xyz, bvh2xyz


% MOCAP

rotVal = skel.tree(1).orientation;
for i = 1:length(skel.tree(1).rotInd)
  rind = skel.tree(1).rotInd(i);
  if rind
    rotVal(i) = rotVal(i) + channels(rind);
  end
end
xyzStruct(1).rot = rotationMatrix(deg2rad(rotVal(1)), ...
                                   deg2rad(rotVal(2)), ...
                                   deg2rad(rotVal(3)), ...
                                   skel.tree(1).axisOrder);

xyzStruct(1).xyz = skel.tree(1).offset;
for i = 1:length(skel.tree(1).posInd)
  pind = skel.tree(1).posInd(i);
  if pind
    xyzStruct(1).xyz(i) = xyzStruct(1).xyz(i) + channels(pind);
  end

end


for i = 1:length(skel.tree(1).children)
  ind = skel.tree(1).children(i);
  xyzStruct = getChildXyz(skel, xyzStruct, ind, channels);
end
xyz = reshape([xyzStruct(:).xyz], 3, length(skel.tree))';

function xyzStruct = getChildXyz(skel, xyzStruct, ind, channels)

% GETCHILDXYZ 

parent = skel.tree(ind).parent;
children = skel.tree(ind).children;
rotVal = zeros(1, 3);
for j = 1:length(skel.tree(ind).rotInd)
  rind = skel.tree(ind).rotInd(j);
  if rind
    rotVal(j) = channels(rind);
  else
    rotVal(j) = 0;
  end
end
tdof = rotationMatrix(deg2rad(rotVal(1)), ...
                      deg2rad(rotVal(2)), ...
                      deg2rad(rotVal(3)), ...
                      skel.tree(ind).order);

torient = rotationMatrix(deg2rad(skel.tree(ind).axis(1)), ...
                         deg2rad(skel.tree(ind).axis(2)), ...
                         deg2rad(skel.tree(ind).axis(3)), ...
                         skel.tree(ind).axisOrder);
torientInv = rotationMatrix(deg2rad(-skel.tree(ind).axis(1)), ...
                            deg2rad(-skel.tree(ind).axis(2)), ...
                            deg2rad(-skel.tree(ind).axis(3)), ...
                            skel.tree(ind).axisOrder(end:-1:1));
xyzStruct(ind).rot = torientInv*tdof*torient*xyzStruct(parent).rot;
xyzStruct(ind).xyz = xyzStruct(parent).xyz + (skel.tree(ind).offset*xyzStruct(ind).rot);

for i = 1:length(children)
  cind = children(i);
  xyzStruct = getChildXyz(skel, xyzStruct, cind, channels);
end
