function options = bvhOptions

% BVHOPTIONS The default options for modelling bvh data.

options = gplvmOptions;
options.gplvmKern = 1;
options.initX = 'sppca';
