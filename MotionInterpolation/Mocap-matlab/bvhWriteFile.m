function bvhWriteFile(fileName, skel, channels, frameLength)

% BVHWRITEFILE Write a bvh file from a given structure and channels.
% FORMAT
% DESC writes a bvh file from a given structure and channels.
% ARG fileName : the file name to use.
% ARG skel : the skeleton structure to use.
% ARG channels : the channels to use.
% ARG frameLength : the length of a frame.
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : bvhReadFile
 
% MOCAP

if nargin < 4
  frameLength = 0.03333;
end

global SAVECHANNELS
SAVECHANNELS = [];

fid = fopen(fileName, 'w');
depth = 0;
printedNodes = [];
fprintf(fid, 'HIERARCHY\n')
i = 1;
while ~any(printedNodes==i)
  printedNodes = printNode(fid, 1, skel, printedNodes, depth, channels);
end
fprintf(fid, 'MOTION\n')
fprintf(fid, 'Frames: %d\n', size(channels, 1));
fprintf(fid, 'Frame Time: %2.6f\n', frameLength);
for i = 1:size(channels, 1)
  for j = 1:size(channels, 2)
    fprintf(fid, '%2.4f ', SAVECHANNELS(i, j));
  end
  fprintf(fid, '\n');
end
fclose(fid);



function printedNodes = printNode(fid, j, skel, printedNodes, ...
                                  depth, channels);

% PRINTNODE Print out the details from the given node.

global SAVECHANNELS

prePart = computePrePart(depth);
if depth > 0
  if strcmp(skel.tree(j).name, 'Site')
    fprintf(fid, [prePart 'End Site\n']);
  else
    fprintf(fid, [prePart 'JOINT %s\n'], skel.tree(j).name);
  end
else
  fprintf(fid, [prePart 'ROOT %s\n'], skel.tree(j).name);
end
fprintf(fid, [prePart '{\n']);
depth = depth + 1;
prePart = computePrePart(depth);
fprintf(fid, [prePart 'OFFSET %2.4f %2.4f %2.4f\n'], ...
        skel.tree(j).offset(1), ...
        skel.tree(j).offset(2), ...
        skel.tree(j).offset(3));
if ~strcmp(skel.tree(j).name, 'Site')
  fprintf(fid, [prePart 'CHANNELS %d'], length(skel.tree(j).channels));
  if any(strcmp('Xposition', skel.tree(j).channels))
    SAVECHANNELS = [SAVECHANNELS channels(:, skel.tree(j).posInd(1))];
    fprintf(fid, ' Xposition');
  end
  if any(strcmp('Yposition', skel.tree(j).channels))
    SAVECHANNELS = [SAVECHANNELS channels(:, skel.tree(j).posInd(2))];
    fprintf(fid, ' Yposition');
  end
  if any(strcmp('Zposition', skel.tree(j).channels))
    SAVECHANNELS = [SAVECHANNELS channels(:, skel.tree(j).posInd(3))];
    fprintf(fid, ' Zposition');
  end
  if any(strcmp('Zrotation', skel.tree(j).channels))
    SAVECHANNELS = [SAVECHANNELS channels(:, skel.tree(j).rotInd(3))];
    fprintf(fid, ' Zrotation');
  end
  if any(strcmp('Xrotation', skel.tree(j).channels))
    SAVECHANNELS = [SAVECHANNELS channels(:, skel.tree(j).rotInd(1))];
    fprintf(fid, ' Xrotation');
  end
  if any(strcmp('Yrotation', skel.tree(j).channels))
    SAVECHANNELS = [SAVECHANNELS channels(:, skel.tree(j).rotInd(2))];
    fprintf(fid, ' Yrotation');
  end
  fprintf(fid, '\n');
end
  
% print out channels
printedNodes = j;
for i = skel.tree(j).children
  printedNodes = [printedNodes printNode(fid, i, skel, printedNodes, ...
                                         depth, channels)];
end
depth = depth - 1;
prePart = computePrePart(depth);
fprintf(fid, [prePart '}\n']);


function prePart = computePrePart(depth);

prePart = [];
for i = 1:depth
  prePart = [prePart '\t'];
end
