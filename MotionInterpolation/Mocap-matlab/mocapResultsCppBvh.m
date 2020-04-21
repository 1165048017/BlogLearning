function mocapResultsCppBvh(fileName, bvhFileName, dataType, varargin)

% MOCAPRESULTSCPPBVH Load results from cpp file and visualise as a bvh format.
% FORMAT
% DESC loads results form a model file saved using C++ code and visualise.
% ARG fileName : the file saved by the C++ code.
% ARG bvhFileName : the file containing the bvh data.
% ARG visualisationType : the root word associated with the visualisation.
% ARG P1, P2, P3 ... : optional additional arguments passed to the
% visualise commands.
%
% SEEALSO : fgplvmVisualise, bvhReadFile, fgplvmReadFromFile
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006, 2007

% MOCAP

[model, labels] = fgplvmReadFromFile(fileName);
bvhStruct = bvhReadFile(bvhFileName);

maxInd = 0;
for i=1:length(bvhStruct.tree)
  for j= 1:size(bvhStruct.tree(i).rotInd, 2)
    if bvhStruct.tree(i).rotInd(j)>maxInd
      maxInd = bvhStruct.tree(i).rotInd(j);
    end
  end
  for j= 1:size(bvhStruct.tree(i).posInd, 2)
    if bvhStruct.tree(i).posInd(j)>maxInd
      maxInd = bvhStruct.tree(i).posInd(j);      
    end
  end
end
padding = maxInd - size(model.y, 2);
% Visualise the results
switch size(model.X, 2) 
 case 1
%  gplvmVisualise1D(model, [dataType 'Visualise'], [dataType 'Modify'], ...
%		   bvhStruct, padding, varargin{:});
  
 case 2
  fgplvmVisualise(model, labels, [dataType 'Visualise'], [dataType 'Modify'], ...
                 bvhStruct, padding, varargin{:});
  
 otherwise 
  error('No visualisation code for data of this latent dimension.');
end
