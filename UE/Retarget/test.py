import numpy as np
np.set_printoptions(suppress=True)

# UE的欧拉角转旋转矩阵
def euler_to_rotMat(yaw, pitch, roll):
    yaw = np.deg2rad(yaw)
    pitch = np.deg2rad(pitch)
    roll = np.deg2rad(roll)

    Rz_yaw = np.array([
        [np.cos(yaw), -np.sin(yaw), 0],
        [np.sin(yaw),  np.cos(yaw), 0],
        [          0,            0, 1]])
    Ry_pitch = np.array([
        [ np.cos(pitch), 0, np.sin(pitch)],
        [             0, 1,             0],
        [-np.sin(pitch), 0, np.cos(pitch)]])
    Rx_roll = np.array([
        [1,            0,             0],
        [0, np.cos(roll), -np.sin(roll)],
        [0, np.sin(roll),  np.cos(roll)]])
    rotMat = np.dot(Rz_yaw, np.dot(Ry_pitch, Rx_roll))
    return rotMat

def anglebetween(v1,v2):
    v1 = v1/np.linalg.norm(v1)
    v2 = v2/np.linalg.norm(v2)
    dot_product = np.dot(v1, v2)
    angle = np.arccos(dot_product)
    return np.rad2deg(angle)

print("---------------T pose ----------------------")
'''
Tpose相关
'''
oriOffset = np.array([-0.000000,35.000000,-0.000000]) # v1 ******************
tarOffset = np.array([45.206524,-0.000000,-0.000002]) # v2 ******************
# 源骨骼Tpose的right hip关节world rotation: (Pitch=0.000000,Yaw=0.000000,Roll=89.996216)
oriSkelT = euler_to_rotMat(0.000000, 0.000000, -89.996216) #T1*************
print(np.dot(oriSkelT, oriOffset)) 
# 目标骨骼Tpose的right hip关节world rotation: (Pitch=-89.786018,Yaw=-90.887756,Roll=-89.115906)
tarSkelT = euler_to_rotMat(-90.887756, 89.786018, 89.115906) #T2*************
print(np.dot(tarSkelT, tarOffset))
print(anglebetween(np.dot(oriSkelT, oriOffset), np.dot(tarSkelT, tarOffset)))

'''
Anim相关
'''
print("---------------Anim pose ----------------------")
# 源骨骼第10帧动画的right hip关节world rotation: (Pitch=-9.146088,Yaw=-63.208164,Roll=74.355972)
oriSkelAnim = euler_to_rotMat(-63.208164, 9.146088, -74.355972)#T3 *************
print(np.dot(oriSkelAnim, oriOffset))
# 目标骨骼第10帧动画的right hip关节world rotation: (Pitch=-72.118958,Yaw=56.725945,Roll=58.820042)
tarSkelAnim = euler_to_rotMat(56.725945, 72.118958, -58.820042)#T4 ************
print(np.dot(tarSkelAnim, tarOffset))
print(anglebetween(np.dot(oriSkelAnim, oriOffset), np.dot(tarSkelAnim, tarOffset)))
print("---------------Test ----------------------")
# 利用一个向量测试旋转数据
vec = np.array([1,2,3])
tmpMat = np.dot(oriSkelAnim,np.matmul(np.linalg.inv(oriSkelT),tarSkelT))#np.dot(np.matmul(oriSkelAnim,np.linalg.inv(oriSkelT)),tarSkelT)
vec1 = np.dot(tmpMat,vec)
vec2 = np.dot(tarSkelAnim,vec)
print(tmpMat)
print(tarSkelAnim)
print(anglebetween(vec1, vec2))


'''
位移测试
'''
print("----------------位移测试(局部)--------------------")
# # Tpose下机器人和小女孩(pelvis local positon)
# tran1 = np.array([0.000000,-83.999985,0.000015])
# tran2 = np.array([106.468117,-0.000013,0.000061])

# # 第10帧机器人和小女孩
# tran3 = np.array([-162.444809,-83.566299,-66.443306])
# tran4 = np.array([105.918175,-79.540977,207.745621]) 

# # 第1000帧机器人和小女孩
# tran5 = np.array([-135.590073,-81.912315,-85.598053])
# tran6 = np.array([103.821510,-104.581665,174.265549]) 
print("----------------位移测试(全局)--------------------")
# Tpose下机器人和小女孩(pelvis world positon)
tran1 = np.array([0.000000,-0.005569,83.999969])
tran2 = np.array([0.002693,0.000016,106.468102])

# 第10帧机器人和小女孩
tran3 = np.array([-162.444809,-66.448837,83.561867])
tran4 = np.array([(-205.898224,-84.200836,105.923523)]) 

# 第1000帧机器人和小女孩
tran5 = np.array([-135.590073,-85.603470,81.906609])
tran6 = np.array([-171.862610,-108.480934,103.825958]) 

print(np.linalg.norm(tran1)/np.linalg.norm(tran2))
print(np.linalg.norm(tran3)/np.linalg.norm(tran4))
print(np.linalg.norm(tran5)/np.linalg.norm(tran6))
print(tran3/tran4)
print(tran5/tran6)