function channels = smoothAngleChannels(channels, skel);

% SMOOTHANGLECHANNELS Try and remove artificial discontinuities associated with angles.

% MOCAP

for i=1:length(skel.tree)
  for j=1:length(skel.tree(i).rotInd)    
    col = skel.tree(i).rotInd(j);
    if col
      for k=2:size(channels, 1)
        diff=channels(k, col)-channels(k-1, col);
        if abs(diff+360)<abs(diff)
          channels(k:end, col)=channels(k:end, col)+360;
        elseif abs(diff-360)<abs(diff)
          channels(k:end, col)=channels(k:end, col)-360;
        end        
      end
    end
  end
end
