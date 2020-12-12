import os
import numpy as np
from scipy.spatial.distance import cdist

import matplotlib.pyplot as plt

class RBFFactory():
    """
    Factory class that spawns the radial basis functions.

    :Example:
        
        >>> from pygem import RBFFactory
        >>> import numpy as np
        >>> x = np.linspace(0, 1)
        >>> for fname in RBFFactory.bases:
        >>>     y = RBFFactory(fname)(x)
    """
    @staticmethod
    def gaussian_spline(X, r=1):
        """
        It implements the following formula:

        .. math::
            \\varphi(\\boldsymbol{x}) = e^{-\\frac{\\boldsymbol{x}^2}{r^2}}

        :param numpy.ndarray X: the norm x in the formula above.
        :param float r: the parameter r in the formula above.

        :return: result: the result of the formula above.
        :rtype: float
        """
        result = np.exp(-(X * X) / (r * r))
        return result

    @staticmethod
    def multi_quadratic_biharmonic_spline(X, r=1):
        """
        It implements the following formula:

        .. math::
            \\varphi(\\boldsymbol{x}) = \\sqrt{\\boldsymbol{x}^2 + r^2}

        :param numpy.ndarray X: the norm x in the formula above.
        :param float r: the parameter r in the formula above.

        :return: result: the result of the formula above.
        :rtype: float
        """
        result = np.sqrt((X * X) + (r * r))
        return result

    @staticmethod
    def inv_multi_quadratic_biharmonic_spline(X, r=1):
        """
        It implements the following formula:

        .. math::
            \\varphi(\\boldsymbol{x}) =
            (\\boldsymbol{x}^2 + r^2 )^{-\\frac{1}{2}}

        :param numpy.ndarray X: the norm x in the formula above.
        :param float r: the parameter r in the formula above.

        :return: result: the result of the formula above.
        :rtype: float
        """
        result = 1.0 / (np.sqrt((X * X) + (r * r)))
        return result

    @staticmethod
    def thin_plate_spline(X, r=1):
        """
        It implements the following formula:

        .. math::
            \\varphi(\\boldsymbol{x}) =
            \\left(\\frac{\\boldsymbol{x}}{r}\\right)^2
            \\ln\\frac{\\boldsymbol{x}}{r}

        :param numpy.ndarray X: the norm x in the formula above.
        :param float r: the parameter r in the formula above.

        :return: result: the result of the formula above.
        :rtype: float
        """
        arg = X / r
        result = arg * arg
        result = np.where(arg > 0, result * np.log(arg), result)
        return result

    @staticmethod
    def beckert_wendland_c2_basis(X, r=1):
        """
        It implements the following formula:

        .. math::
            \\varphi(\\boldsymbol{x}) = 
            \\left( 1 - \\frac{\\boldsymbol{x}}{r}\\right)^4 +
            \\left( 4 \\frac{ \\boldsymbol{x} }{r} + 1 \\right)

        :param numpy.ndarray X: the norm x in the formula above.
        :param float r: the parameter r in the formula above.

        :return: result: the result of the formula above.
        :rtype: float
        """
        arg = X / r
        first = np.where((1 - arg) > 0, np.power((1 - arg), 4), 0)
        second = (4 * arg) + 1
        result = first * second
        return result

    @staticmethod
    def polyharmonic_spline(X, r=1, k=2):
        """
        It implements the following formula:

        .. math::
            
            \\varphi(\\boldsymbol{x}) =
                \\begin{cases}
                \\frac{\\boldsymbol{x}}{r}^k
                    \\quad & \\text{if}~k = 1,3,5,...\\\\
                \\frac{\\boldsymbol{x}}{r}^{k-1}
                \\ln(\\frac{\\boldsymbol{x}}{r}^
                {\\frac{\\boldsymbol{x}}{r}})
                    \\quad & \\text{if}~\\frac{\\boldsymbol{x}}{r} < 1,
                    ~k = 2,4,6,...\\\\
                \\frac{\\boldsymbol{x}}{r}^k
                \\ln(\\frac{\\boldsymbol{x}}{r})
                    \\quad & \\text{if}~\\frac{\\boldsymbol{x}}{r} \\ge 1,
                    ~k = 2,4,6,...\\\\
                \\end{cases}

        :param numpy.ndarray X: the norm x in the formula above.
        :param float r: the parameter r in the formula above.

        :return: result: the result of the formula above.
        :rtype: float
        """

        r_sc = X / r

        # k odd
        if k & 1:
            return np.power(r_sc, k)

        # k even
        result = np.where(r_sc < 1,
                          np.power(r_sc, k - 1) * np.log(np.power(r_sc, r_sc)),
                          np.power(r_sc, k) * np.log(r_sc))
        return result

class RBF():
    """
    Class that handles the Radial Basis Functions interpolation on the mesh
    points.

    :param numpy.ndarray original_control_points: it is an
        (*n_control_points*, *3*) array with the coordinates of the original
        interpolation control points before the deformation. The default is the
        vertices of the unit cube.
    :param numpy.ndarray deformed_control_points: it is an
        (*n_control_points*, *3*) array with the coordinates of the
        interpolation control points after the deformation. The default is the
        vertices of the unit cube.
    :param func: the basis function to use in the transformation. Several basis
        function are already implemented and they are available through the
        :py:class:`~pygem.rbf.RBF` by passing the name of the right
        function (see class documentation for the updated list of basis
        function).  A callable object can be passed as basis function.
    :param float radius: the scaling parameter r that affects the shape of the
        basis functions.  For details see the class
        :class:`RBF`. The default value is 0.5.
    :param dict extra_parameter: the additional parameters that may be passed to
    	the kernel function. Default is None.
        
    :cvar numpy.ndarray weights: the matrix formed by the weights corresponding
        to the a-priori selected N control points, associated to the basis
        functions and c and Q terms that describe the polynomial of order one
        p(x) = c + Qx.  The shape is (*n_control_points+1+3*, *3*). It is
        computed internally.
    :cvar numpy.ndarray original_control_points: it is an
        (*n_control_points*, *3*) array with the coordinates of the original
        interpolation control points before the deformation.
    :cvar numpy.ndarray deformed_control_points: it is an
        (*n_control_points*, *3*) array with the coordinates of the
        interpolation control points after the deformation.
    :cvar callable basis: the basis functions to use in the
        transformation.
    :cvar float radius: the scaling parameter that affects the shape of the
        basis functions.
    :cvar dict extra_parameter: the additional parameters that may be passed to
    	the kernel function.
        
    :Example:

        >>> from pygem import RBF
        >>> import numpy as np
        >>> rbf = RBF('gaussian_spline')
        >>> xv = np.linspace(0, 1, 20)
        >>> yv = np.linspace(0, 1, 20)
        >>> zv = np.linspace(0, 1, 20)
        >>> z, y, x = np.meshgrid(zv, yv, xv)
        >>> mesh = np.array([x.ravel(), y.ravel(), z.ravel()])
        >>> deformed_mesh = rbf(mesh)
    """
    def __init__(self,
                 original_control_points,
                 deformed_control_points,
                 func='gaussian_spline',
                 radius=0.5,
                 extra_parameter=None):

        __bases = {
        'gaussian_spline': RBFFactory.gaussian_spline,
        'multi_quadratic_biharmonic_spline': RBFFactory.multi_quadratic_biharmonic_spline,
        'inv_multi_quadratic_biharmonic_spline': RBFFactory.inv_multi_quadratic_biharmonic_spline,
        'thin_plate_spline': RBFFactory.thin_plate_spline,
        'beckert_wendland_c2_basis': RBFFactory.beckert_wendland_c2_basis,
        'polyharmonic_spline': RBFFactory.polyharmonic_spline
        }

        self.basis = __bases[func]
        self.radius = radius

        assert original_control_points is not None
        assert deformed_control_points is not None
        
        self.original_control_points = original_control_points       
        self.deformed_control_points = deformed_control_points

        self.extra = extra_parameter if extra_parameter else dict()

        self.weights = self._get_weights(self.original_control_points,
                                         self.deformed_control_points)


    @property
    def n_control_points(self):
        """
        Total number of control points.

        :rtype: int
        """
        return self.original_control_points.shape[0]


    def _get_weights(self, X, Y):
        """
        This private method, given the original control points and the deformed
        ones, returns the matrix with the weights and the polynomial terms, that
        is :math:`W`, :math:`c^T` and :math:`Q^T`. The shape is
        (*n_control_points+1+3*, *3*).

        :param numpy.ndarray X: it is an n_control_points-by-3 array with the
            coordinates of the original interpolation control points before the
            deformation.
        :param numpy.ndarray Y: it is an n_control_points-by-3 array with the
            coordinates of the interpolation control points after the
            deformation.

        :return: weights: the 2D array with the weights and the polynomial terms.
        :rtype: numpy.ndarray
        """
        npts, dim = X.shape
        H = np.zeros((npts + 3 + 1, npts + 3 + 1))
        H[:npts, :npts] = self.basis(cdist(X, X), self.radius)#, **self.extra)
        H[npts, :npts] = 1.0
        H[:npts, npts] = 1.0
        H[:npts, -3:] = X
        H[-3:, :npts] = X.T

        rhs = np.zeros((npts + 3 + 1, dim))
        rhs[:npts, :] = Y
        weights = np.linalg.solve(H, rhs)
        return weights

    def __str__(self):
        """
        This method prints all the RBF parameters on the screen. Its purpose is
        for debugging.
        """
        string = ''
        string += 'basis function = {}\n'.format(self.basis)
        string += 'radius = {}\n'.format(self.radius)
        string += '\noriginal control points =\n'
        string += '{}\n'.format(self.original_control_points)
        string += '\ndeformed control points =\n'
        string += '{}\n'.format(self.deformed_control_points)
        return string

    def plot_points(self, filename=None):
        """
        Method to plot the control points. It is possible to save the resulting
        figure.

        :param str filename: if None the figure is shown, otherwise it is saved
            on the specified `filename`. Default is None.
        """
        fig = plt.figure(1)
        axes = fig.add_subplot(111, projection='3d')
        orig = axes.scatter(self.original_control_points[:, 0],
                            self.original_control_points[:, 1],
                            self.original_control_points[:, 2],
                            c='blue',
                            marker='o')
        defor = axes.scatter(self.deformed_control_points[:, 0],
                             self.deformed_control_points[:, 1],
                             self.deformed_control_points[:, 2],
                             c='red',
                             marker='x')

        axes.set_xlabel('X axis')
        axes.set_ylabel('Y axis')
        axes.set_zlabel('Z axis')

        plt.legend((orig, defor), ('Original', 'Deformed'),
                   scatterpoints=1,
                   loc='lower left',
                   ncol=2,
                   fontsize=10)

        # Show the plot to the screen
        if filename is None:
            plt.show()
        else:
            fig.savefig(filename)

    def compute_weights(self):
        """
        This method compute the weights according to the
        `original_control_points` and `deformed_control_points` arrays.
        """
        self.weights = self._get_weights(self.original_control_points,
                                         self.deformed_control_points)

    def __call__(self, src_pts):
        """
        This method performs the deformation of the mesh points. After the
        execution it sets `self.modified_mesh_points`.
        """
        self.compute_weights()

        H = np.zeros((src_pts.shape[0], self.n_control_points + 3 + 1))
        H[:, :self.n_control_points] = self.basis(
            cdist(src_pts, self.original_control_points), 
            self.radius)
            #**self.extra)
        H[:, self.n_control_points] = 1.0
        H[:, -3:] = src_pts
        return np.asarray(np.dot(H, self.weights))
