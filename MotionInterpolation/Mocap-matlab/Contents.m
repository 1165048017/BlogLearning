% gplvm toolbox
% Version 1.01 Monday, June 9, 2003 at 18:24:38
% Copyright (c) 2003 Neil D. Lawrence
% $Revision: 1.3 $
% 
% CLASSVISUALISE Callback function for visualising data in 2-D.
% GTMOIL For visualising oil data --- uses NETLAB toolbox.
% GPLVMBRENDAN Model the face data with a 2-D GPLVM.
% GPLVMDIGITS Model the digits data with a 2-D GPLVM.
% GPLVMGRADIENT Gradient of likelihood with respect to parameters.
% PDINV Computes the inverse of a positive definite matrix
% INVGETNORMAXESPOINT Take a point on a plot and return a point within the figure
% GPLVMGRADIENTPOINT Compute gradient of data-point likelihood wrt x.
% GPLVMOIL Model the oil data with a 2-D GPLVM.
% GPLVMMAKEAVI1D Create a movie of the fantasies along a line (as a movie).
% GPLVMGRADIENTX Compute gradient of data-point likelihood wrt x.
% GPLVMIVM THis code implements active set selection (via the IVM) for the GPLVM
% GPLVMLIKELIHOOD Calculate the likelihood of the data set.
% GPLVMPLOTDIGITS Generate a showing the scatter plot of the digits.
% KERNELDIFFPARAMS Get gradients of kernel wrt its parameters.
% KERNEL Compute the rbf kernel
% GPLVMLIKELIHOODPOINT Compute gradient of data-point likelihood wrt x.
% VECTORVISUALISE  Helper code for plotting a vector during 2-D visualisation.Plot the oil data
% GPLVMVISUALISE Visualise the manifold.
% KPCAOIL Demonstrate kernel parameter selection with the sub-set of the oil data.
% VECTORMODIFY Helper code for visualisation of vectorial data.
% IMAGEMODIFY Helper code for visualisation of image data.
% KERNELDIAG Compute the diagonal of the kernel function
% IMAGEVISUALISE Helper code for showing an image during 2-D visualisation.
% MANIFOLDOUTPUTS Evaluate the manifold output for datapoints X.
% GPLVMRESULTSDIGITS1D Load and visualise the 1-D results for the digits.
% THETACONSTRAIN Prevent kernel parameters from getting too big or small.
% GPLVMBRENDANAVI Make AVI files of faces data.
% GPLVMPLOTBRENDAN1D Generate a figure containing fantasy brendans for NIPS paper.
% COMPUTEKERNEL Compute the kernel matrix for data X with parameters theta.
% GPLVMFIT Fit a Gaussian process latent variable model.
% GPLVMRESULTSDIGITS Load and visualise the 2-D results of the digits.
% log(det(A)) where A is positive-definite.
% GPLVMDIGITSAVI Make AVI files of digits data.
% GPLVMDATAMAKEAVI1D Create a movie of the data along the line.
% GPLVMBRENDAN1D Model the face data with a 1-D GPLVM.
% GPLVMVISUALISE1D Visualise the fantasies along a line (as a movie).
% SCGGPLVMOIL Run the full SCG GPLVM algorithm on 100 oil data points
% GPLVMDIGITS1D Model the digit data with a 1-D GPLVM.
% GPLVMVISUALISEDATA1D Visualise the ordering of the data across the line.
% GPLVMRESULTSBRENDAN1D Load and visualise the 1-D results for the faces.
% KERNELDIFFX Compute the gradient of the kernel with respect to X.
% GPLVMRESULTSBRENDAN Load and visualise the 2-D results of Brendan's face.
% GPLVRESULTSMOIL Load and visualise the results for the oil algorithm.
