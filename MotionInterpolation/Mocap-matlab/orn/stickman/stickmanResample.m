function [resampledPoints] = stickmanResample(points, sampleSize)

indices = randperm(size(points, 1));
resampledPoints = zeros(sampleSize, size(points, 2));

for i = 1:sampleSize
    resampledPoints(i, :) = points(indices(i), :);
end