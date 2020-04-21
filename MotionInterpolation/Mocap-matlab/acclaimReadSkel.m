function skel = acclaimReadSkel(fileName)
% ACCLAIMREADSKEL Reads an ASF file into a skeleton structure.
% FORMAT
% DESC loads skeleton structure from an acclaim skeleton file.
% ARG fileName : the file name to load in.
% RETURN skel : the skeleton for the file.
% 
% COPYRIGHT : Neil D. Lawrence, 2006
% 
% SEEALSO : acclaimLoadChannels

% MOCAP

% a regular expression for floats
numPat = '(-?[0-9]*\.?[0-9]*)';
% a regular expression for positive ints
intPat = '([0-9]+)';

boneCount = 0;
fid = fopen(fileName, 'r');
lin = fgetl(fid);
lin = strtrim(lin);
skel.length = 1.0;
skel.mass = 1.0;
skel.angle = 'deg';
skel.type = 'acclaim';
skel.documentation = '';
skel.name = fileName;
while ~feof(fid)
  if lin(1)==':'
    switch lin(2:end)
     case 'name'
      lin = fgetl(fid);
      lin = strtrim(lin);
      skel.name = lin;
     case 'units'
      lin = fgetl(fid);
      lin = strtrim(lin);
      while(lin(1) ~= ':')
        parts = tokenise(lin, ' ');
        switch parts{1}
         case 'mass'
          skel.mass = str2num(parts{2});
         case 'length'
          skel.length = str2num(parts{2});
         case 'angle'
          skel.angle = strtrim(parts{2});
        end
        lin = fgetl(fid);
        lin = strtrim(lin);
      end
     case 'documentation'
      skel.documentation = [];
      lin = fgetl(fid);
      while(lin(1) ~=':')
        skel.documentation = [skel.documentation char(13) lin];
        lin = fgetl(fid);
      end
      lin = strtrim(lin);
      
     case 'root'
      skel.tree(1) = struct('name', 'root', ...
                            'id', 0, ...
                            'offset', [], ...
                            'orientation', [], ...
                            'axis', [0 0 0], ...
                            'axisOrder', [], ...
                            'C', eye(3), ...
                            'Cinv', eye(3), ...
                            'channels', [], ...
                            'bodymass', [], ...
                            'confmass', [], ...
                            'parent', 0, ...
                            'order', [], ...
                            'rotInd', [], ...
                            'posInd', [], ...
                            'children', [], ...
                            'limits', []);
      lin = fgetl(fid);
      lin = strtrim(lin);
      while(lin(1) ~= ':')
        parts = tokenise(lin, ' ');
        switch parts{1}
         case 'order'
          order = [];
          for i = 2:length(parts)            
            switch lower(parts{i})
             case 'rx'
              chan = 'Xrotation';
              order = [order 'x'];
             case 'ry'
              chan = 'Yrotation';
              order = [order 'y'];
             case 'rz'
              chan = 'Zrotation';
              order = [order 'z'];
             case 'tx'
              chan = 'Xposition';
             case 'ty'
              chan = 'Yposition';
             case 'tz'
              chan = 'Zposition';
             case 'l'
              chan = 'length';
            end
            skel.tree(boneCount+1).channels{i-1} = chan;
          end
          % order is reversed compared to bvh
          skel.tree(boneCount+1).order = order(end:-1:1);

         case 'axis'
          % order is reversed compared to bvh
          skel.tree(1).axisOrder = lower(parts{2}(end:-1:1));
         case 'position'
          skel.tree(1).offset = [str2num(parts{2}) ...
                              str2num(parts{3}) ...
                              str2num(parts{4})];
         case 'orientation'
          skel.tree(1).orientation =  [str2num(parts{2}) ...
                              str2num(parts{3}) ...
                              str2num(parts{4})];
        end
        lin = fgetl(fid);
        lin = strtrim(lin);
      end
     case 'bonedata'
      lin = fgetl(fid);
      lin = strtrim(lin);
      while(lin(1)~=':')
        parts = tokenise(lin, ' ');
        switch parts{1}
         case 'begin'
          boneCount = boneCount + 1;
          skel.tree(boneCount + 1) = struct('name', [], ...
                                            'id', [], ...
                                            'offset', [], ...
                                            'orientation', [], ...
                                            'axis', [0 0 0], ...
                                            'axisOrder', [], ...
                                            'C', eye(3), ...
                                            'Cinv', eye(3), ...
                                            'channels', [], ...
                                            'bodymass', [], ...
                                            'confmass', [], ...
                                            'parent', [], ...
                                            'order', [], ...
                                            'rotInd', [], ...
                                            'posInd', [], ...
                                            'children', [], ...
                                            'limits', []);
          lin = fgetl(fid);
          lin = strtrim(lin);
         
         case 'id'
          skel.tree(boneCount+1).id = str2num(parts{2});
          lin = fgetl(fid);
          lin = strtrim(lin);
          skel.tree(boneCount+1).children = [];
         
         case 'name'
          skel.tree(boneCount+1).name = parts{2};
          lin = fgetl(fid);
          lin = strtrim(lin);
         
         case 'direction'
          direction = [str2num(parts{2}) str2num(parts{3}) str2num(parts{4})];
          lin = fgetl(fid);
          lin = strtrim(lin);
         
         case 'length'
          lgth =  str2num(parts{2});
          lin = fgetl(fid);
          lin = strtrim(lin);
         
         case 'axis'
          skel.tree(boneCount+1).axis =  [str2num(parts{2}) ...
                              str2num(parts{3}) ...
                              str2num(parts{4})];
          % order is reversed compared to bvh
          skel.tree(boneCount+1).axisOrder =  lower(parts{end}(end:-1:1));
          lin = fgetl(fid);
          lin = strtrim(lin);
         
         case 'dof'
          order = [];
          for i = 2:length(parts)            
            switch parts{i}
             case 'rx'
              chan = 'Xrotation';
              order = [order 'x'];
             case 'ry'
              chan = 'Yrotation';
              order = [order 'y'];
             case 'rz'
              chan = 'Zrotation';
              order = [order 'z'];
             case 'tx'
              chan = 'Xposition';
             case 'ty'
              chan = 'Yposition';
             case 'tz'
              chan = 'Zposition';
             case 'l'
              chan = 'length';
            end
            skel.tree(boneCount+1).channels{i-1} = chan;
          end
          % order is reversed compared to bvh
          skel.tree(boneCount+1).order = order(end:-1:1);
          lin = fgetl(fid);
          lin = strtrim(lin);
         
         case 'limits'
          limitsCount = 1;
          skel.tree(boneCount+1).limits(limitsCount, 1:2) = ...
              [str2num(parts{2}(2:end)) str2num(parts{3}(1:end-1))];
          
          lin = fgetl(fid);
          lin = strtrim(lin);
          while(~strcmp(lin, 'end'))
            parts = tokenise(lin, ' ');

            limitsCount = limitsCount + 1;
            skel.tree(boneCount+1).limits(limitsCount, 1:2) = ...
                [str2num(parts{1}(2:end)) str2num(parts{2}(1:end-1))];
            lin = fgetl(fid);
            lin = strtrim(lin);
          end
         
         case 'end'
          skel.tree(boneCount+1).offset = direction*lgth;
          lin = fgetl(fid);
          lin = strtrim(lin);
        end
        
      end
    
     case 'hierarchy'
      lin = fgetl(fid);
      lin = strtrim(lin);
      while(~strcmp(lin, 'end'))
        parts = tokenise(lin, ' ');
        if ~strcmp(lin, 'begin')
          ind = skelReverseLookup(skel, parts{1});
          for i = 2:length(parts)
            skel.tree(ind).children = [skel.tree(ind).children ...
                                skelReverseLookup(skel, parts{i})];
          end        
        end
        lin = fgetl(fid);
        lin = strtrim(lin);
      end
      if feof(fid)
        skel = finaliseStructure(skel);
        return
      end
      
     otherwise
      if feof(fid)
        skel = finaliseStructure(skel);
        return
      end
      lin = fgetl(fid);
      lin = strtrim(lin);
    end
  else
      lin=fgetl(fid);
      lin=strtrim(lin);
%     if isempty(lin)
%       continue
%     else
%       error('Unrecognised file format');
%     end
  end
end

function skel = finaliseStructure(skel)

% FINALISESTRUCTURE 

skel.tree = treeFindParents(skel.tree);
ordered = false;
while ordered == false
  for i = 1:length(skel.tree)
    ordered = true;
    if(skel.tree(i).parent>i)
      ordered = false;
      skel.tree = swapNode(skel.tree, i, skel.tree(i).parent);
    end
  end
end

for i = 1:length(skel.tree)
  skel.tree(i).C = rotationMatrix(deg2rad(skel.tree(i).axis(1)), ...
                             deg2rad(skel.tree(i).axis(2)), ...
                             deg2rad(skel.tree(i).axis(3)), ...
                             skel.tree(i).axisOrder);
  skel.tree(i).Cinv = inv(skel.tree(i).C);
end


