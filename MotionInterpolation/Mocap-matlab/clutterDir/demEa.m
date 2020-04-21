% DEMEA Show the saved results of demEa1.

load demEa1
labelInfo(1).text = 'Neutral';
labelInfo(1).indices = [1:20]';
labelInfo(2).text = 'Happy';
labelInfo(2).indices = [21:27 96:105]';
labelInfo(3).text = 'Sad';
labelInfo(3).indices = [30:38]';
labelInfo(4).text = 'Fear';
labelInfo(4).indices = [40:47]';
labelInfo(5).text = 'Suprise';
labelInfo(5).indices = [49:58]';
labelInfo(6).text = 'Anger';
labelInfo(6).indices = [60:68]';
labelInfo(7).text = 'Disgust';
labelInfo(7).indices = [70:78]';
labelInfo(8).text = 'Maniac';
labelInfo(8).indices = [80:95]';
labelInfo(9).text = 'Transition';
labelInfo(9).indices = [28:29 39 48 59 69 79]';

numData = size(Y, 1);
% Visualise the results
mocapFaceVisualise(X, Y, invK, theta, [], meanData, 1:numData, ...
                   labelInfo, 'face2DVisualise', 'face2DModify', patches);
