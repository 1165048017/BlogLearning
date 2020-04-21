function patches = mocapFacePatches(fileName);

% MOCAPFACEPATCHES Give a connection matrix for the motion capture data.

fid = fopen(fileName);
i = 1;
rem = fgets(fid);	
while(rem ~= -1)
  patches(i) = struct('index', [], 'colour', []);
  patches(i).index = sscanf(rem, '%d')+1;
  i = i+1;
  rem = fgets(fid);	
end
colour = ones(1, 1, 3);
for i = 1:length(patches)
  patches(i).colour = colour;
end