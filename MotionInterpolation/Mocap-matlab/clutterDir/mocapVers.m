function [vers, depend] = mocapVers

% MOCAPPATH Brings dependent toolboxes into the path.

vers = 0.001;
if nargout > 2
  depend(1).name = 'gplvm';
  depend(1).vers = 2.02;
  depend(1).required = 0;
end
