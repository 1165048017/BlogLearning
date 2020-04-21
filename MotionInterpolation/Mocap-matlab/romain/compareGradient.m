%test Gradient

skel = acclaimReadSkel('./data/13.asf');
[channels, skel] = acclaimLoadChannels('13_39.amc', skel);

gradient =  computeGradient(skel,channels(1,:));

epsilon  = 0.0000001;
[lin siz] = size(gradient);

result = zeros(lin,siz);

vect = zeros(lin,siz);

for k=1:siz

channels_epsilonPlus       = channels(1,:);
channels_epsilonPlus(1,k)  = channels_epsilonPlus(1,k) + epsilon ;
channels_epsilonMoins      = channels(1,:);
channels_epsilonMoins(1,k) = channels_epsilonMoins(1,k) - epsilon ;



xyz  = skel2xyz(skel, channels_epsilonPlus);
xyz2 = skel2xyz(skel, channels_epsilonMoins);

toCompare = (xyz - xyz2)/(2*epsilon);

vect(:,k) = convertxyz2Vect(toCompare)';


%This is the matrix where the values are the comparison between the real
%gradient and the variation rate (all the values should be close to 1
result(:,k) = vect(:,k) ./ gradient(:,k);

end

 