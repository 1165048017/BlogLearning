function [skel, channels, frameLength] = bvhReadFile(fileName)

% BVHREADFILE Reads a bvh file into a tree structure.
% FORMAT
% DESC reads a bvh file into a tree structure and obtains the channels.
% RETURN skel : the tree structure of the skeleton.
% RETURN channels : the channels of the data read in.
% RETURN frameLength : the time for each frame.
% ARG fileName : the name of the file to read in, in bvh format.
%
% COPYRIGHT : Neil D. Lawrence, 2005
%
% SEEALSO : acclaimReadSkel, bvhPlayFile, bvhWriteFile


% MOCAP

% a regular expression for floats
%  numPat = '(-?[0-9]*\.?[0-9]*)';
numPat = '(-?[0-9]*\.?[0-9]*[eE]?-?[0-9]*)'; 
% a regular expression for positive ints
intPat = '([0-9]+)';


fid = fopen(fileName, 'r');
numBracket = 0;
% start the backtrace with 0 (the parent of the root node).
backTrace = 0;
jointNo = 0;
channelNo = 0;
skel.type = 'bvh';
skel.mass = 1.0;
skel.length = 1.0;
skel.angle = 'deg';
skel.documentation = '';
skel.name = fileName;
while ~feof(fid)
  lin = fgetl(fid);
  [token, R] = strtok(lin);

  switch token
   
   case {'ROOT', 'JOINT', 'End'}
    % A joint is starting
    parentNo = backTrace(numBracket+1);
    jointNo = jointNo + 1;
    name = strtok(R); 
    skel.tree(jointNo) = struct('name', name, ...
                                'id', jointNo - 1, ...
                                'offset', [], ...
                                'orientation', [], ...
                                'axis', [0 0 0], ...
                                'axisOrder', [], ...
                                'C', eye(3), ...
                                'Cinv', eye(3), ...
                                'channels', [], ...
                                'bodymass', [], ...
                                'confmass', [], ...
                                'parent', parentNo, ...
                                'order', [], ...
                                'rotInd', [], ...
                                'posInd', [], ...
                                'children', [], ...
                                'limits', []);
    backTrace = [backTrace jointNo];
    
   case 'OFFSET'
    % Read in the offset.    
    offsets = regexp(R, numPat, 'tokens');
    if length(offsets) == 3
      for i = 1:3
        offset = str2num(offsets{i}{1});
        skel.tree(jointNo).offset(1, i) = offset;
      end
    else 
      error('Offset is incorrect length.');
    end
   
   case '{'    
    numBracket = numBracket + 1;
    
   case '}'
    numBracket = numBracket - 1;
    backTrace = backTrace(1:end-1);
   
   case 'CHANNELS'
    % Read in the channels     
    [tok, R] = strtok(R); 
    numChannels = str2num(tok);
    orderNo = 0;
    for i = 1:numChannels 
      [tok, R] = strtok(R);
      skel.tree(jointNo).channels{i} = tok;
      switch tok
       case 'Xrotation'
        orderNo = orderNo + 1;
        skel.tree(jointNo).rotInd(1, 1) = channelNo + i;
        skel.tree(jointNo).order(1, orderNo) = 'x';
       case 'Yrotation'
        orderNo = orderNo + 1;
        skel.tree(jointNo).rotInd(1, 2) = channelNo + i;
        skel.tree(jointNo).order(1, orderNo) = 'y';
       case 'Zrotation'
        orderNo = orderNo + 1;
        skel.tree(jointNo).rotInd(1, 3) = channelNo + i;
        skel.tree(jointNo).order(1, orderNo) = 'z';
       case 'Xposition'
        skel.tree(jointNo).posInd(1, 1) = channelNo + i;
       case 'Yposition'
        skel.tree(jointNo).posInd(1, 2) = channelNo + i;
       case 'Zposition'
        skel.tree(jointNo).posInd(1, 3) = channelNo + i;
      end        
    end
    skel.tree(jointNo).order = char(skel.tree(jointNo).order);
    channelNo = channelNo + numChannels;
   
   case 'MOTION'
    lin = fgetl(fid);
    pat = ['Frames:\s*' intPat]; 
    frames = regexpi(lin, pat, 'tokens');
    if length(frames) == 1
      dataStruct.numFrames = str2num(frames{1}{1});
    else
      error('Cannot determine number of frames in file.')
    end
    
    lin = fgetl(fid);
    pat = ['Frame Time:\s*' numPat]; 
    frameLength = regexpi(lin, pat, 'tokens');
    if length(frameLength)
      frameLength = str2num(frameLength{1}{1});
    else
      error('Cannot determine length of frames in file.')
    end
    
    channels = [];
    while ~feof(fid)
      lin = fgetl(fid);
      chanLine = sscanf(lin, '%f');
      channels = [channels; chanLine'];
    end
  end
end
fclose(fid);
skel.tree = treeFindChildren(skel.tree);


channels = smoothAngleChannels(channels, skel);


