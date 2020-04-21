function bvhResultsDynamic(dataSet, number, dataType, bvhStruct, velocityIndices)

% BVHRESULTSDYNAMIC Load a results file and visualise them.
  
[model, bvhStruct, frameLength] = bvhLoadResult(dataSet, number);

if size(model.X, 2) ~=2
  error('Visualisation only works for 2-D latent spaces.')
end
mocapVisualise(model, ones(size(model.X, 1), 1), ...
               str2func([dataType 'Visualise']), ...
               str2func([dataType 'Modify']), ...
               bvhStruct, velocityIndices);
