function mocapPlayData(fileName)

% MOCAPPLAYDATA 

[Y, connections] = mocapLoadData(fileName);

pauseVal = 0.01;
handle = stickVisualise(Y(1, :), connections);
pause
disp('Press a key')
for j = 1:20
  for i = 1:size(Y, 1)
    pause(pauseVal);
    stickModify(handle, Y(i, :), connections);
  end
end