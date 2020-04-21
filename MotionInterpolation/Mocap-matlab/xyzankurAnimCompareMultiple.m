function xyzankurAnimCompareMultiple(X, X2, fps, names)

% XYZANKURANIMCOMPAREMULTIPLE Animate many predictions and ground truth for
% stick man from Agarwal & Triggs dataset.
% FORMAT
% DESC animates a matrix of x,y,z point cloud positions representing the
% motion of the figure used to generate the silhouttes for Agarwal &
% Triggs silhouette data.
% ARG x : the ground truth to animate.
% ARG x2 : Cell of other predictions to animate.
% ARG fps : the number of frames per second to animate (defaults to 24).
%
% SEEALSO : xyzankurVisualise, xyzankurModify
%
% COPYRIGHT : Carl Henrik Ek and Neil D. Lawrence, 2008
%
% MODIFICATIONS : Alfredo A. Kalaitzis, 2011

% MOCAP

nDatasets = length(X2);
more_handles = zeros(nDatasets,19);
if(nargin < 3)
    fps = 24;
    if(nargin < 1)
        error('Too few arguments');
    end
end

clf
for i = 1:1:size(X,1)
    if (i == 1)
        subplot(1, nDatasets+1, 1), title(names{1})
        handle = xyzankurVisualise(X(i,:), 1);
        for j = 1:nDatasets
            subplot(1, nDatasets+1, j+1), title(names{j+1})
            more_handles(j,:) = xyzankurVisualise(X2{j}(i,:), 1);
        end
    else
        xyzankurModify(handle, X(i,:));
        for j = 1:nDatasets
            xyzankurModify(more_handles(j,:), X2{j}(i,:));
        end
    end
    pause(1/fps);
end
