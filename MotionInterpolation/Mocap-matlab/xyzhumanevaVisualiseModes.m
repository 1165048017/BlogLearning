function xyzhumanevaVisualiseModes(Z,Zgt,fid,display)

% XYZHUMANEVAVISUALISEMODES
%
% COPYRIGHT : Carl Henrik Ek and Neil Lawrence, 2008

% MOCAP


if(nargin<4)
  display = false;
  if(nargin<3)
    fid = 1;
  end
end

figure(fid);clf;figure(fid+1);clf;

button = 1;
i = 1;
while(button~=3&&i<=length(Z))
  if(display)
    fprintf('Frame:\t%d\n',i);
  end
  if(exist('Zgt','var'))
    if(i==1)
      handle_gt = xyzhumanevaVisualise(Zgt(i,:),fid);
    else
      handle_gt = xyzhumanevaModify(handle_gt,Zgt(i,:));
    end
  end

  figure(fid+1);
  for(j = 1:1:min(size(Z{i},1),8))
    subplot(2,4,j);
    if(exist('handle_mode')&&length(handle_mode)>=j)
      handle_mode{j} = xyzhumanevaModify(handle_mode{j},Z{i}(j,:));
    else
      handle_mode{j} = xyzhumanevaVisualise(Z{i}(j,:),fid+1);
    end
  end
  if(exist('handle_mode'))
    if(length(handle_mode)>=j)
      for(j = 1:1:min(size(Z{i},1),8))
	tmp{j} = handle_mode{j};
      end
      handle_mode = tmp;
      clear tmp;
    end
  end
  
  for(k = min(size(Z{i},1),8)+1:1:8)
    subplot(2,4,k);plot(0,0,'r');
  end
  
  [void1 void2 button] = ginput(1);
  i = i+1;
end


return
