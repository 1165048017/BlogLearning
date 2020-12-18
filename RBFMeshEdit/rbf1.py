import os
import numpy as np
from scipy.spatial.distance import cdist

import matplotlib.pyplot as plt

class RBFFactory():
    @staticmethod
    def gaussian_spline(X, r=1):
        result = np.exp(-(X * X) / (r * r))
        return result

    @staticmethod
    def multi_quadratic_biharmonic_spline(X, r=1):
        result = np.sqrt((X * X) + (r * r))
        return result

    @staticmethod
    def inv_multi_quadratic_biharmonic_spline(X, r=1):
        result = 1.0 / (np.sqrt((X * X) + (r * r)))
        return result

    @staticmethod
    def thin_plate_spline(X, r=1):
        arg = X / r
        result = arg * arg
        result = np.where(arg > 0, result * np.log(arg), result)
        return result

    @staticmethod
    def beckert_wendland_c2_basis(X, r=1):
        arg = X / r
        first = np.where((1 - arg) > 0, np.power((1 - arg), 4), 0)
        second = (4 * arg) + 1
        result = first * second
        return result

    @staticmethod
    def polyharmonic_spline(X, r=1, k=2):
        r_sc = X / r

        # k odd
        if k & 1:
            return np.power(r_sc, k)

        # k even
        result = np.where(r_sc < 1,
                          np.power(r_sc, k - 1) * np.log(np.power(r_sc, r_sc)),
                          np.power(r_sc, k) * np.log(r_sc))
        return result
    
    @staticmethod
    def official(X):
        return np.sqrt(np.log10(X+1.0))

class RBF():   
    def __init__(self,
                 original_control_points,
                 deformed_control_points,
                 func='gaussian_spline'):

        __bases = {
        'gaussian_spline': RBFFactory.gaussian_spline,
        'multi_quadratic_biharmonic_spline': RBFFactory.multi_quadratic_biharmonic_spline,
        'inv_multi_quadratic_biharmonic_spline': RBFFactory.inv_multi_quadratic_biharmonic_spline,
        'thin_plate_spline': RBFFactory.thin_plate_spline,
        'beckert_wendland_c2_basis': RBFFactory.beckert_wendland_c2_basis,
        'polyharmonic_spline': RBFFactory.polyharmonic_spline,
        'official':RBFFactory.official
        }

        self.basis = __bases[func]

        assert original_control_points is not None
        assert deformed_control_points is not None
        
        self.original_control_points = original_control_points       
        self.deformed_control_points = deformed_control_points


        self.weights = self._get_weights(self.original_control_points, 
                                        self.deformed_control_points - self.original_control_points)

    @property
    def n_control_points(self):
        return self.original_control_points.shape[0]

    def _get_weights(self, X, Y):
        npts, dim = X.shape
        G = np.zeros((npts + 3 + 1, npts + 3 + 1))
        G[:npts, :npts] = self.basis(cdist(X, X)) #g(dist)
        G[npts, :npts] = 1.0
        G[:npts, npts] = 1.0
        G[:npts, -3:] = X
        G[-3:, :npts] = X.T

        rhs = np.zeros((npts + 3 + 1, dim))
        rhs[:npts, :] = Y
        weights = np.linalg.solve(G, rhs)
        return weights

    def __str__(self):
        string = ''
        string += 'basis function = {}\n'.format(self.basis)
        string += '\noriginal control points =\n'
        string += '{}\n'.format(self.original_control_points)
        string += '\ndeformed control points =\n'
        string += '{}\n'.format(self.deformed_control_points)
        return string

    def compute_weights(self):
        self.weights = self._get_weights(self.original_control_points,
                                         self.deformed_control_points)

    def __call__(self, src_pts):
        H = np.zeros((src_pts.shape[0], self.n_control_points + 3 + 1))
        H[:, :self.n_control_points] = self.basis(cdist(src_pts, self.original_control_points))
        H[:, self.n_control_points] = 1.0
        H[:, -3:] = src_pts
        return np.asarray(src_pts + np.dot(H, self.weights))
