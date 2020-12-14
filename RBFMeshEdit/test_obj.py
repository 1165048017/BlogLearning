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

def getRadius(verts):
    center = np.array([0,0,0])
    for i in range(verts.shape[0]):
        center = center + verts[i,...]
    center = center/verts.shape[0]
    radius = 0
    for i in range(verts.shape[0]):
        if(radius<np.linalg.norm(verts[i,...]-center)):
            radius = np.linalg.norm(verts[i,...]-center)
    return radius

verts1,faces1 = read("test1.obj")
verts1_index = [3250,226,	3130,3977,3620,3270,  93,956,597,247,	   332,2443,2609,2411,3097,76,  4954,2360,1931,1547,2309,1506,  1833,2207]

verts2,faces2 = read("test2.obj")
verts2_index = [265,995,	1247,1248,100,591,    792,671,1252,1250,	574,610,785,578,32,812,     92,1228,800,1236,1242,620,      619,607]


writeWithColor(verts1,faces1,verts1_index,"out1.obj")
writeWithColor(verts2,faces2,verts2_index,"out2.obj")

# RBF变形
original_control_points = verts1[verts1_index,...]
deformed_control_points  = verts2[verts2_index,...]
# RBF function
func_name = "gaussian_spline"
# RBF radius
radius = getRadius(verts1)
print("mesh1:{0},mesh2:{1}\n".format(radius,getRadius(verts2)))
rbf = RBF(original_control_points,deformed_control_points,func_name,0.5)# radius
new_verts = rbf(verts1)
writeWithColor(new_verts,faces1,verts1_index,"deformed.obj")
print("new radius:",getRadius(new_verts))
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
