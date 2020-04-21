function gradient = computeGradient(skel,channels)

% COMPUTEGRADIENT computes the matrix gradient of the skelaton
% given a set of channels
%
%	Description:
%
%	gradient = computeGradient(skel,channels)
%	
%	 Returns:
%	  GRADIENT - the matrix gradient
%	 Arguments:
%	  SKEL - a skeleton structure 
%	  CHANNELS - the channels where the gradient has to be computes


skelTmp = skel.tree(1);
gradient = eye(3);


for i = 1:length(skel.tree(1).children)
    ind = skel.tree(1).children(i);
    gradient = computeGradientChildren(skel, gradient, ind, channels);
end


% gradient for children


function gradient = computeGradientChildren(skel, gradient, ind, channels);

parent = skel.tree(ind).parent;

%copy the lines of the parent
gradient((ind-1)*3+1,:)= gradient((parent-1)*3+1,:);
gradient((ind-1)*3+2,:)= gradient((parent-1)*3+2,:);
gradient((ind-1)*3+3,:)= gradient((parent-1)*3+3,:);

gradient = updateGradient(skel, channels, gradient, ind);

children = skel.tree(ind).children;

for i = 1:length(children)
    cind = children(i);
    gradient = computeGradientChildren(skel, gradient, cind, channels);
end

% update cells in gradient matrix

function gradient = updateGradient(skel, channels, gradient, ind)

parent = skel.tree(ind).parent;
skelParent = skel.tree(ind);

while (parent~=0)
    %parent
    for j = 1:length(skelParent.rotInd)
        rind = skelParent.rotInd(j);
        if rind
            if (j == 1)
                [gradientTmp matrix] = pseudoGradient(skel, channels, 'x', 0,rind, ind);
            else
                if (j == 2)
                    [gradientTmp matrix] = pseudoGradient(skel, channels, 'y', 0,rind, ind);
                else
                    [gradientTmp matrix] = pseudoGradient(skel, channels, 'z', 0,rind, ind);

                end
            end

            if    (rind>size(gradient,2))
                %if cells does not exist
                gradient((ind-1)*3+1,rind) = 0.0175*gradientTmp(1);
                gradient((ind-1)*3+2,rind) = 0.0175*gradientTmp(2);
                gradient((ind-1)*3+3,rind) = 0.0175*gradientTmp(3);
            else
                %if there is already a value in the cells
                gradient((ind-1)*3+1,rind) = gradient((ind-1)*3+1,rind) + 0.0175*gradientTmp(1);
                gradient((ind-1)*3+2,rind) = gradient((ind-1)*3+2,rind) + 0.0175*gradientTmp(2);
                gradient((ind-1)*3+3,rind) = gradient((ind-1)*3+3,rind) + 0.0175*gradientTmp(3);
            end

        else
        end
    end

    parent = skelParent.parent;
    if parent
        skelParent = skel.tree(parent);

    end
end


