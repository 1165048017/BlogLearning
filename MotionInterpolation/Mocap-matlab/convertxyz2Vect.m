function vect = convertxyz2Vect(xyz)

% CONVERTXYZ2VECT convert an xyz matrix into a vector.
%
%	Description:
%
%	channelsFinal = gradientDescent(skel, initialChannels, finalChannels,
%	error,step)
%	
%	 Returns:
%	 VECT - a line vector
%	 Arguments:
%	 XYZ - the xyz matrix to be transformed

for i=1:size(xyz,1)
    for j=1:size(xyz,2)
        vect((i-1)*3 + j) = xyz(i,j);
    end
end