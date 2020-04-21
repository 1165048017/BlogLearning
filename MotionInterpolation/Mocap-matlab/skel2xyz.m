function xyz = skel2xyz(skel, channels)

% SKEL2XYZ Compute XYZ values given skeleton structure and channels.
% FORMAT
% DESC Computes X, Y, Z coordinates given a BVH or acclaim skeleton
% structure and an associated set of channels.
% ARG skel : a skeleton for the bvh file.
% ARG channels : the channels for the bvh file.
% RETURN xyz : the point cloud positions for the skeleton.
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : acclaim2xyz, bvh2xyz

% MOCAP

fname = str2func([skel.type '2xyz']);
xyz = fname(skel, channels);
