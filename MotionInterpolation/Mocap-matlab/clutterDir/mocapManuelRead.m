function [columnNames, data] = mocapManuelRead(fileName)

% MOCAPMANUELREAD Read in data which has column titles in the first line and separated values in each other line.

if nargin < 2
  separator = ',';
end



fid = fopen(fileName);
numMarkers = str2num(fgetl(fid));
numLines = str2num(fgetl(fid));
framesPerSecond = str2num(fgetl(fid));

lin = fgetl(fid);
columnNames = stringSplit(lin, ';');
numCol = length(columnNames);
i = 0;
data = zeros(numLines, (numCol - 1)*3+1);
delim = sprintf('\t');
while 1
  i = i+1;
  lin=fgetl(fid);
  if ~ischar(lin), break, end
  split = stringSplit(deblank(lin), delim);
%  if length(split) ~= numMarkers*3
%    error(['Error at line ' num2str(i) ' of file ' fileName ': wrong ' ...
%                        'number of columns'])
%  end
  for j = 2:length(split);
    data(i, j) = str2num(split{j});
  end
end
fclose(fid);