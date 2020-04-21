function handle = bvhVisualise(channels, skel, padding)

% BVHVISUALISE For updating a bvh representation of 3-D data.
% FORMAT
% DESC draws a bvh representation in a 3-D plot.
% ARG channels : the channels to update the skeleton with.
% ARG skel : the skeleton structure.
% RETURN handle : a vector of handles to the plotted structure.
%
% SEEALSO : bvhModify, skelVisualise
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006

% MOCAP

if nargin < 3
  padding = 0;
end
handle = skelVisualise(channels, skel, padding);
