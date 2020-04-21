function tokens = tokenise(string, delim)

% TOKENISE Split a string into separate tokens.
%
% tokens = tokenise(string, delim)
%

% Copyright (c) 2006 Neil D. Lawrence
% tokenise.m version 1.1



if nargin < 2
  delim = ' ';
end
tokpos = find(string==delim);
len=length(tokpos);

if len==0
  tokens{1} = string;
elseif len==1
  tokens{1} = string(1:tokpos(1)-1);
  tokens{2} = string(tokpos(1)+1:end);
elseif len>1
  tokens{1} = string(1:tokpos(1)-1);
  for(i=2:len)
    tokens{i} = string(tokpos(i-1)+1:tokpos(i)-1);
  end
  tokens{len+1} = string(tokpos(len)+1:end);
end