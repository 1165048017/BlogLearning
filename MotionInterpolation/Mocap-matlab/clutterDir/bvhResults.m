function bvhResults(dataSet, experimentNo)

% BVHRESULTS Model Demonstration of modelling of BVH files.

[bvhStruct, Y, frameLength, velocityIndices] = bvhLoadData(dataSet);
bvhResultsDynamic(dataSet, experimentNo, 'bvh', bvhStruct, velocityIndices)
