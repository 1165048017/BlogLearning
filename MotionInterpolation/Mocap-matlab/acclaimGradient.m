function g = acclaimGradient(skel,channels)

% ACCLAIMGRADIENT computes the gradient of x,y,z locations wrt angles.
% FORMAT
% DESC computes the gradient of the x, y and z locations of the skeleton
% with respect to the each of the channels.
% RETURN g : the gradient with the x, y, and z of each joint in the rows
% and the channels in the columns.
% ARG skel : the acclaim skeleton structure.
% ARG channels : the channels where the gradient is computed.
%
% COPYRIGHT : Romain Floyrac, 2009
%
% MODIFICATIONS : Neil D. Lawrence, 2009
  
% MOCAP

skelTmp = skel.tree(1);
g = eye(3);


for i = 1:length(skel.tree(1).children)
  ind = skel.tree(1).children(i);
  g = computeGradientChildren(skel, gradient, ind, channels);
end




function g = computeGradientChildren(skel, g, ind, channels);
% gradient for children

  parent = skel.tree(ind).parent;
  
  %copy the lines of the parent
  g((ind-1)*3+1,:)= g((parent-1)*3+1,:);
  g((ind-1)*3+2,:)= g((parent-1)*3+2,:);
  g((ind-1)*3+3,:)= g((parent-1)*3+3,:);
  
  g = updateGradient(skel, channels, g, ind);
  
  children = skel.tree(ind).children;
  
  for i = 1:length(children)
    cind = children(i);
    g = computeGradientChildren(skel, g, cind, channels);
  end
end

function g = updateGradient(skel, channels, g, ind)
% update cells in gradient matrix
  
  parent = skel.tree(ind).parent;
  skelParent = skel.tree(ind);
  
  while (parent~=0)
    %parent
    for j = 1:length(skelParent.rotInd)
      rind = skelParent.rotInd(j);
      if rind
        if (j == 1)
          [gTmp matrix] = pseudoGradient(skel, channels, 'x', 0,rind, ind);
        else
          if (j == 2)
            [gTmp matrix] = pseudoGradient(skel, channels, 'y', 0,rind, ind);
          else
            [gTmp matrix] = pseudoGradient(skel, channels, 'z', 0,rind, ind);
            
          end
        end
        
        if (rind>size(g,2))
          %if cells does not exist
          g((ind-1)*3+1,rind) = 0.0175*gTmp(1);
          g((ind-1)*3+2,rind) = 0.0175*gTmp(2);
          g((ind-1)*3+3,rind) = 0.0175*gTmp(3);
        else
          %if there is already a value in the cells
          g((ind-1)*3+1,rind) = g((ind-1)*3+1,rind) + 0.0175*gTmp(1);
          g((ind-1)*3+2,rind) = g((ind-1)*3+2,rind) + 0.0175*gTmp(2);
          g((ind-1)*3+3,rind) = g((ind-1)*3+3,rind) + 0.0175*gTmp(3);
        end
        
      else
      end
    end
    
    parent = skelParent.parent;
    if parent
      skelParent = skel.tree(parent);
    end
  end
end

