function   channelsFinal = gradientDescent(skel, initialChannels, finalChannels, error,step)

% GRADIENTDESCENT Computes a sequence of channels from an initial position to a final one, using least square function as objective function and gradient descent.
%
%	Description:
%
%	channelsFinal = gradientDescent(skel, initialChannels, finalChannels,
%	error,step)
%	
%	 Returns:
%	 channelsFinal - a sequence of channels
%	 Arguments:
%	  skel - a skeleton structure 
%	  INITIALCHANNELS - a channel that representes the initial position of
%	  the gradient descent
%     FINALCHANNELS - the final channels that the gradient descent tends to
%     reach
%     ERROR - stopping criterion. The gradient norm has to be below this
%     value
%     STEP - step value between two loops


channels   = initialChannels;
finalXYZ   = convertxyz2Vect(skel2xyz(skel,finalChannels));
initialXYZ = convertxyz2Vect(skel2xyz(skel,initialChannels));
tmp        = initialXYZ - finalXYZ
first      = acclaimGradient(skel,channels);

gradient  = 2*tmp*first;

normeGradient = norm(gradient,'fro');
channelsFinal(1,:) = channels;
h=2;

u=1;

while (normeGradient>error)
    
    channels   = channels - step*gradient;
    tmpXYZ     = convertxyz2Vect(skel2xyz(skel,channels));
    tmpXYZ     = tmpXYZ - finalXYZ;
    first      = computeGradient(skel,channels);
    gradient   = 2*tmpXYZ*first;
    normeGradient = norm(gradient,'fro');
    
    fprintf(1,'norm gradient: %f\n',normeGradient);
    u=u+1;

    %retrieve 1 channels out of 2 for memory saving
    if mod(u,2)
        channelsFinal(h,:) = channels;
        h = h + 1;
    end

end

