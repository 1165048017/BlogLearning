import numpy as np

import matplotlib.pyplot as plt

# rShldrBend 0, rForearmBend 1, rHand 2, rThumb2 3, rMid1 4,
# lShldrBend 5, lForearmBend 6, lHand 7, lThumb2 8, lMid1 9,
# lEar 10, lEye 11, rEar 12, rEye 13, Nose 14,
# rThighBend 15, rShin 16, rFoot 17, rToe 18,
# lThighBend 19,  lShin 20, lFoot 21, lToe 22,
# abdomenUpper 23, hip 24, head 25, neck 26, spine 27
parent =[26,0,1,2,2, 26,5,6,7,7, 11,14,13,14,25, 24,15,16,17, 24,19,20,21, 24,-1,26,27,23]
jointnum = 28
dataOri = np.reshape(np.loadtxt("./unity_data/record.txt"),(-1,jointnum,3))
framenum = dataOri.shape[0]

datakalman = np.zeros_like(dataOri)
datafinal = np.zeros_like(dataOri)

# kalman filter parameters
KalmanParamQ = 0.001
KalmanParamR = 0.0015
K = np.zeros((jointnum,3),dtype=np.float32)
P = np.zeros((jointnum,3),dtype=np.float32)
X = np.zeros((jointnum,3),dtype=np.float32)
# low pass filter parameters
PrevPose3D = np.zeros((6,jointnum,3),dtype=np.float32)
for idx in range(framenum):
    currdata = np.squeeze(dataOri[idx])
    smooth_kps = np.zeros((jointnum,3),dtype=np.float32)
    '''
    kalman filter
    '''
    for i in range(jointnum):
        K[i] = (P[i] + KalmanParamQ) / (P[i] + KalmanParamQ + KalmanParamR)
        P[i] = KalmanParamR * (P[i] + KalmanParamQ) / (P[i] + KalmanParamQ + KalmanParamR)
    for i in range(jointnum):
        smooth_kps[i] = X[i] + (currdata[i] - X[i])*K[i]
        X[i] = smooth_kps[i]

    datakalman[idx] = smooth_kps # record kalman result

    '''
    low pass filter
    '''    
    LowPassParam = 0.1
    PrevPose3D[0] = smooth_kps
    for j in range(1,6):
        PrevPose3D[j] = PrevPose3D[j] * LowPassParam + PrevPose3D[j - 1] * (1.0 - LowPassParam)
    datafinal[idx] = PrevPose3D[5] # record kalman+low pass result.

'''
visualization
'''
# visualize original/pythonsmooth/unitysmooth z coordinates for the joint 17
dataSmooth = np.reshape(np.loadtxt("./unity_data/recordSmooth.txt"),(-1,28,3))
x1 = np.arange(0,framenum,1)
y1 = np.squeeze(dataOri[:,17,1])
x2 = np.arange(0,dataSmooth.shape[0],1)
y2 = np.squeeze(dataSmooth[:,17,1])
plt.plot(x1,y1)
plt.plot(x2,y2,linewidth = 1)
plt.plot(x1,datakalman[:,17,1],linewidth=2,linestyle=":")
plt.plot(x1,datafinal[:,17,1],linewidth=1,linestyle="-.")
plt.legend(["original","unitySmooth","kalman","kalman+lowpass"])
plt.show()

# visualize the skeleton animation
fig = plt.figure()
plt.ion()
data = datafinal#dataOri
for i in range(framenum):   
    fig.clf() 
    kps = np.squeeze(data[i,...])    
    ax = fig.gca(projection='3d')
    ax.xaxis.set_label_text(label="x")
    ax.yaxis.set_label_text(label="y")
    ax.zaxis.set_label_text(label="z")
    ax.set_xlim(np.min(data[...,0]),np.max(data[...,0]))
    ax.set_ylim(np.min(data[...,2]),np.max(data[...,2]))
    ax.set_zlim(np.min(data[...,1]),np.max(data[...,1]))
    ax.view_init(elev=26., azim=70)    
    ax.scatter3D(kps[:,0],-kps[:,2],kps[:,1],'red')
    for i in range(28):
        if(parent[i]!=-1):
            ax.plot3D(kps[[i,parent[i]],0], -kps[[i,parent[i]],2], kps[[i,parent[i]],1], 'gray')
    plt.pause(0.02)    
plt.ioff()
plt.show()