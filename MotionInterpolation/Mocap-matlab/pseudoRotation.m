function matrix = pseudoRotation(skel, channels, ind2Compute)

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

skelTmp = skel.tree(ind2Compute);
parent = skelTmp.parent;
skelParent = skel.tree(parent);
matrix = eye(3);

while (parent~=0)

    skelParent = skel.tree(parent);
    
rotVal = zeros(1, 3);
    for j = 1:length(skelParent.rotInd)
        rind = skelParent.rotInd(j);
        if rind
            rotVal(j) = channels(rind);
        else
            rotVal(j) = 0;
        end
    end


    tdof = rotationMatrix(deg2rad(rotVal(1)), ...
        deg2rad(rotVal(2)), ...
        deg2rad(rotVal(3)), ...
        skelParent.order);
    torient = rotationMatrix(deg2rad(skelParent.axis(1)), ...
        deg2rad(skelParent.axis(2)), ...
        deg2rad(skelParent.axis(3)), ...
        skelParent.axisOrder);
    torientInv = rotationMatrix(deg2rad(-skelParent.axis(1)), ...
        deg2rad(-skelParent.axis(2)), ...
        deg2rad(-skelParent.axis(3)), ...
        skelParent.axisOrder(end:-1:1));

    matrix = matrix*torientInv*tdof*torient;

    parent = skelParent.parent;

end


