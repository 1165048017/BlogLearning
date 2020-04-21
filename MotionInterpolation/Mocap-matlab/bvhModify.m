function bvhModify(handle, channels, skel, padding)

% BVHMODIFY Helper code for visualisation of bvh data.
% FORMAT
% DESC updates a bvh representation in a 3-D plot.
% ARG handle : a vector of handles to the structure to be updated.
% ARG channels : the channels to update the skeleton with.
% ARG skel : the skeleton structure.
%
% SEEALSO : skelModify, bvhVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006

% MOCAP


if nargin<4
  padding = 0;
end

skelModify(handle, channels, skel, padding);
