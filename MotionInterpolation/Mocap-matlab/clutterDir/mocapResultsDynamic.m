function mocapResultsDynamic(dataSet, number, dataType, varargin)

% MOCAPRESULTSDYNAMIC Load a results file and visualise them.
  
[model, connect] = mocapLoadResult(dataSet, number);

% Visualise the results
switch size(model.X, 2) 
 case 1
  gplvmVisualise1D(model, [dataType 'Visualise'], [dataType 'Modify'], ...
		   connect, varargin{:});
  
 case 2
  gplvmVisualise(model, ones(size(model.X, 1)), [dataType 'Visualise'], [dataType 'Modify'], ...
                 connect, varargin{:});
  
 otherwise 
  error('No visualisation code for data of this latent dimension.');
end