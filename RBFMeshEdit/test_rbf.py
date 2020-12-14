from rbf import RBF
import numpy as np

import matplotlib.pyplot as plt

# orignal 3D points
original_control_points = np.array([[0., 0., 0.], [0., 0., 1.],
                                    [0., 1., 0.], [1., 0., 0.],
                                    [0., 1., 1.], [1., 0., 1.],
                                    [1., 1., 0.], [1., 1., 1.]])
# destinate 3D points
deformed_control_points = np.array([[0.1, 0.2, 0.3], [0., 0., 1.],
                                    [0., 1., 0.], [1., 0., 0.],
                                    [0., 0.8, 1.], [1., 0., 1.],
                                    [1., 1., 0.], [1.2, 1.2, 1.2]])

# RBF function
func_name = "gaussian_spline"
# RBF radius
radius = 1.0

rbf = RBF(original_control_points,deformed_control_points,func_name,radius)


nx, ny, nz = (10, 10, 10)
mesh = np.zeros((nx * ny * nz, 3))
xv = np.linspace(0, 1, nx)
yv = np.linspace(0, 1, ny)
zv = np.linspace(0, 1, nz)
z, y, x = np.meshgrid(zv, yv, xv)
mesh = np.array([x.ravel(), y.ravel(), z.ravel()])
mesh = mesh.T
new_mesh = rbf(mesh)

print(mesh.shape)

fig = plt.figure(1)
ax = fig.add_subplot(111, projection='3d')
ori_mesh = ax.scatter(mesh[:, 0], mesh[:, 1], mesh[:, 2], c='blue', marker='+')
def_mesh = ax.scatter(new_mesh[:, 0], new_mesh[:, 1], new_mesh[:, 2], c='red', marker='^')

orig = ax.scatter(original_control_points[:, 0],
            original_control_points[:, 1],
            original_control_points[:, 2],
            c='black',
            marker='o')

defor=ax.scatter(deformed_control_points[:, 0],
            deformed_control_points[:, 1],
            deformed_control_points[:, 2],
            c='green',
            marker='o')

plt.legend((ori_mesh,def_mesh,orig, defor), 
            ('Original mesh', 'Deformed mesh', 'Original points', 'Deformed points'),
            scatterpoints=1,
            loc='lower left',
            ncol=2,
            fontsize=10)
ax.set_xlabel('X axis')
ax.set_ylabel('Y axis')
ax.set_zlabel('Z axis')
plt.show()