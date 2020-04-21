function [gradient matrix] = pseudoGradient(skel, channels, gradientDirection, ind,rotInd2, ind2Compute)

% PSEUDOGRADIENT ths position function of a node is composed with 2
% terms. The first one is the position of the parent node, the second is an
% additional term to get the real position. This function computes the
% derivative of the second term for the node 'ind2Compute' in respect with
% the channels 'rotInd2' given a set of channels.
% 
%	Description:
%
%	[gradient matrix] = PSEUDOGRADIENT(skel, channels,gradientDirection, ind,rotInd2, ind2Compute)
%	
%	 Returns:
%	  GRADIENT - the coponents of the gradient (x,y,z)
%     MATRIX - the rotation matrix
%	 Arguments:
%	  SKEL - a skeleton structure 
%	  CHANNELS - the channels where the gradient has to be computes
%     GRADIENTDIRECTION - the direction of the gradient
%     IND - a recursive paremeter... start with 0 in general
%     ROTIND2 - the gradient has to be computed in respect with this
%     channel
%     IND2COMPUTE - the node ID where the gradient has to be computed


if (ind == 0)
    ind = ind2Compute;
end
matrix =eye(3);
parent = skel.tree(ind).parent;

rotVal = zeros(1, 3);
derive =0 ;
for j = 1:length(skel.tree(ind).rotInd)
    rind = skel.tree(ind).rotInd(j);
    if (rind == rotInd2)
        derive = 1;
    end
    if rind
        rotVal(j) = channels(rind);
    else
        rotVal(j) = 0;
    end
end

if derive
    tdof = rotationMatrixGradient(deg2rad(rotVal(1)), ...
        deg2rad(rotVal(2)), ...
        deg2rad(rotVal(3)), ...
        skel.tree(ind).order,gradientDirection);



else
    tdof = rotationMatrix(deg2rad(rotVal(1)), ...
        deg2rad(rotVal(2)), ...
        deg2rad(rotVal(3)), ...
        skel.tree(ind).order);

end

torient = rotationMatrix(deg2rad(skel.tree(ind).axis(1)), ...
    deg2rad(skel.tree(ind).axis(2)), ...
    deg2rad(skel.tree(ind).axis(3)), ...
    skel.tree(ind).axisOrder);
torientInv = rotationMatrix(deg2rad(-skel.tree(ind).axis(1)), ...
    deg2rad(-skel.tree(ind).axis(2)), ...
    deg2rad(-skel.tree(ind).axis(3)), ...
    skel.tree(ind).axisOrder(end:-1:1));

if (parent~=0)
    
   [useless matrixTmp] = pseudoGradient(skel, channels, gradientDirection, parent,rotInd2, ind2Compute);
    matrix = torientInv*tdof*torient*matrixTmp;
else

  
    
    derive = 0;
    rotVal = skel.tree(1).orientation;
    for i = 1:length(skel.tree(1).rotInd)
        rind = skel.tree(1).rotInd(i);
            
        if (rind == rotInd2)
            derive = 1;

        end
        if rind
            rotVal(i) = rotVal(i) + channels(rind);
        end
    end
    if derive
           
        matrix2 = rotationMatrixGradient(deg2rad(rotVal(1)), ...
            deg2rad(rotVal(2)), ...
            deg2rad(rotVal(3)), ...
            skel.tree(1).order,gradientDirection);

    else
    
        matrix2 = rotationMatrix(deg2rad(rotVal(1)), ...
            deg2rad(rotVal(2)), ...
            deg2rad(rotVal(3)), ...
            skel.tree(1).axisOrder);

    end
 
    
matrix = matrix * matrix2;
end
gradient = skel.tree(ind2Compute).offset*matrix;

