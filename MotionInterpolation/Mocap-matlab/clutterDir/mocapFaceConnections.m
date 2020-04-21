function connect = mocapFaceConnections(fileName);

% MOCAPFACECONNECTIONS Give a connection matrix for the motion capture data.

fid = fopen(fileName);
i = 1;
rem = fgets(fid);	
while(rem ~= -1)		
  [token, rem] = strtok(rem, ',');
  row = str2num(fliplr(deblank(fliplr(deblank(token)))))+1;
  [token, rem] = strtok(rem, ',');
  col = str2num(fliplr(deblank(fliplr(deblank(token)))))+1;
  i = i + 1;
  connect(row, col) = 1;
  rem = fgets(fid);	
end
connect = connect + connect';
connect(find(connect)) = 1;
connect = tril(connect);
connect = sparse(connect);