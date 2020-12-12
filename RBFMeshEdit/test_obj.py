from rbf import RBF
import numpy as np

import matplotlib.pyplot as plt

def read(obj_file):
    f = open(obj_file,'r')
    contents = f.readlines()
    verts = []
    faces = []
    for idx in range(len(contents)):
        if 'v ' in contents[idx]:
            verts_str = contents[idx].split(" ")
            verts.append([verts_str[1],verts_str[2],verts_str[3]])
        if 'f ' in contents[idx]:
            faces_str = contents[idx].split(" ")
            faces.append([faces_str[1],faces_str[2],faces_str[3]])
    f.close()
    return np.array(verts,dtype='float32'),np.array(faces,dtype=np.int)

def write(v,f,name):
    fp = open(name,'w')
    for i in range(v.shape[0]):
        fp.write("v {0} {1} {2} {3} {4} {5}\n".format(v[i,0],v[i,1],v[i,2],1.0,1.0,1.0))
    for i in range(f.shape[0]):
        fp.write("f {0} {1} {2} \n".format(f[i,0],f[i,1],f[i,2]))
    fp.close()

def writeWithColor(v,f,index,name):
    fp = open(name,'w')
    for i in range(v.shape[0]):
        if(i in index):
            fp.write("v {0} {1} {2} {3} {4} {5}\n".format(v[i,0],v[i,1],v[i,2],1.0,0.0,0.0))
        else:
            fp.write("v {0} {1} {2} {3} {4} {5}\n".format(v[i,0],v[i,1],v[i,2],1.0,1.0,1.0))
    for i in range(f.shape[0]):
        fp.write("f {0} {1} {2} \n".format(f[i,0],f[i,1],f[i,2]))
    fp.close()

verts,faces = read("test.obj")

# 查找五个关键点
face_index = 3375#np.arange(3313,3320)
print(np.unique(faces[face_index,...].flatten()))
verts_index = np.array([1932,4954,5345,1528,1950,1380,3037,4024])# 左嘴角、右嘴角、上嘴唇、下嘴唇、下巴、左耳、右耳、头顶

writeWithColor(verts,faces,verts_index,"out.obj")

# RBF变形
original_control_points = verts[verts_index,...]
deformed_control_points  = verts[verts_index,...]
deformed_control_points[3,...] = deformed_control_points[4,...] + np.array([0,2,0])
deformed_control_points[4,...] = deformed_control_points[5,...] + np.array([0,12,0])
# RBF function
func_name = "gaussian_spline"
# RBF radius
radius = 0.5
rbf = RBF(original_control_points,deformed_control_points,func_name,radius)
new_verts = rbf(verts)
write(new_verts,faces,"deformed.obj")

'''
plot 3D 
'''
# X = np.zeros((3,faces.shape[0]))
# Y = np.zeros((3,faces.shape[0]))
# Z = np.zeros((3,faces.shape[0]))
# for i in range(faces.shape[0]):
#     X[0,i] = verts[faces[i,0]-1,0]
#     X[1,i] = verts[faces[i,1]-1,0]
#     X[2,i] = verts[faces[i,2]-1,0]

#     Y[0,i] = verts[faces[i,0]-1,1]
#     Y[1,i] = verts[faces[i,1]-1,1]
#     Y[2,i] = verts[faces[i,2]-1,1]

#     Z[0,i] = verts[faces[i,0]-1,2]
#     Z[1,i] = verts[faces[i,1]-1,2]
#     Z[2,i] = verts[faces[i,2]-1,2]

# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
# ax.plot_wireframe(X, Y, Z, rstride=100, cstride=100)
# ax.scatter(verts[verts_index,0],verts[verts_index,1],verts[verts_index,2],s=100,c='red')
# ax.set_xlabel("X")
# ax.set_ylabel("Y")
# ax.set_zlabel("Z")

# plt.show()
