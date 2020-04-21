function tree = treeFindParents(tree)

% TREEFINDPARENTS Given a tree that lists only children, add parents.
%
% tree = treeFindParents(tree)
%

% Copyright (c) 2006 Neil D. Lawrence
% treeFindParents.m version 1.1



for i = 1:length(tree)
  for j = 1:length(tree(i).children)
    if tree(i).children(j)
      tree(tree(i).children(j)).parent ...
          = [tree(tree(i).children(j)).parent i];
    end
  end
end

