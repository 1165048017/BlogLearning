function [hd,motion] = read_bvh03(fn)

% READ_BVH03 A bvh reader from the web.

% Chris Bregler and J. Brasket
  fid = fopen(fn,'r');
  hd.str = [];  ch_id = 1; hir_lev = []; hir_name = []; ori = 0;
  while ~feof(fid),
    l = fgetl(fid);
    
    [tok,R] = strtok(l);
    if strcmp(tok,'ROOT') | strcmp(tok,'JOINT'),
      name = [strtok(R),'.']; 
      hir_lev = [hir_lev,length(name)];
      hir_name = [hir_name,name];
    elseif strcmp(tok,'{'),
    elseif strcmp(tok,'}');
      hir_lev = hir_lev(1:end-1);
      hir_name = hir_name(1:sum(hir_lev));
    elseif strcmp(tok,'OFFSET'),
      ori = ori + 1;
      ori_name = hir_name(sum(hir_lev)-hir_lev(end)+1:sum(hir_lev));
      ori_name(end) = [];
      hd.ori_name{ori} = ori_name;
      R0 = R;
      for n = 1:3
        [tok0,R0] = strtok(R0);
        hd.ori(ori,n) = str2num(tok0);
      end
    elseif strcmp(tok,'CHANNELS'),
      [tok0,R0] = strtok(R); 
      num_ch = str2num(tok0);
      for n = ch_id:ch_id+num_ch-1,
        [tok0,R0] = strtok(R0);
        hd.channel{n} = [hir_name,tok0];
      end;
      ch_id = ch_id+num_ch;
    end;
    
    hd.str = [hd.str,'\n',l];
    if strncmp(l,'MOTION',6), break; end;
  end;
  hd.motl1 = fgetl(fid);
  hd.motl2 = fgetl(fid);
  
  motion = []; prev_a = []; offset = 0;
  while ~feof(fid),
    l = fgetl(fid);
    a = sscanf(l,'%f')+offset;
    if ~isempty(prev_a),
%       offset = offset + 360*((a-prev_a) < -180) - 360*((a-prev_a) > 180);
%if(sum((a-prev_a)<-180)), dbstack; keyboard; end;
       a = a+offset;
    end;
    prev_a = a;
    motion = [motion;a'];
  end;
  fclose(fid);
  
% postprocessing

% fix the redundant names in hd.ori_name
for k = 2:length(hd.ori_name)
  if strcmp(hd.ori_name{k},hd.ori_name{k-1})
    hd.ori_name{k} = [hd.ori_name{k},'End'];
  end
end
 
%dbstack; keyboard
