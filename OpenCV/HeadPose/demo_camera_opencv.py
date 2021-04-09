import numpy as np
import cv2

obj, index = np.load("./model/head_pose_object_points.npy", allow_pickle=True)
obj = obj.T *10
obj[...,1] = -obj[...,1]
obj[...,0] = obj[...,0] - obj[...,0].min()+10
obj[...,1] = obj[...,1] - obj[...,1].min()+10

pick_model = [7,2, 22,18, 14,10,  30, 34,35,36,37,38]

# 人脸关键点检测
cas = cv2.CascadeClassifier('./model/haarcascade_frontalface_alt2.xml')
facemodel = cv2.face.createFacemarkLBF()
facemodel.loadModel('./model/lbfmodel.yaml')

def draw_pick_kps(show_img,kps,pickidx,drawsize=2):
    kps = kps.astype('int')
    for idx in pickidx:
        show_img = cv2.circle(show_img,(kps[idx][0],kps[idx][1]),drawsize,(255,0,255),-1)
    return show_img

def draw_axis(img, euler_angle, center, size=80, thickness=3,
                  angle_const=np.pi/180, copy=False):
        if copy:
            img = img.copy()
        
        cv2.putText(show_img,str(euler_angle[0]), (20,20), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2)
        cv2.putText(show_img,str(euler_angle[1]), (20,50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2)
        cv2.putText(show_img,str(euler_angle[2]), (20,80), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2)

        euler_angle *= angle_const
        sin_pitch, sin_yaw, sin_roll = np.sin(euler_angle)
        cos_pitch, cos_yaw, cos_roll = np.cos(euler_angle)

        axis = np.array([
            [cos_yaw * cos_roll,
             cos_pitch * sin_roll + cos_roll * sin_pitch * sin_yaw],
            [-cos_yaw * sin_roll,
             cos_pitch * cos_roll - sin_pitch * sin_yaw * sin_roll],
            [sin_yaw,
             -cos_yaw * sin_pitch]
        ])

        axis *= size
        axis += center

        axis = axis.astype(np.int)
        tp_center = tuple(center.astype(np.int))

        cv2.line(img, tp_center, tuple(axis[0]), (0, 0, 255), thickness)
        cv2.line(img, tp_center, tuple(axis[1]), (0, 255, 0), thickness)
        cv2.line(img, tp_center, tuple(axis[2]), (255, 0, 0), thickness)

        return img

def detect_facepoint(img):
    img_gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    faces = cas.detectMultiScale(img_gray,2,3,0,(30,30))
    if(len(faces)==0):
        return 0,0,0
    landmarks = facemodel.fit(img_gray,faces)
    assert landmarks[0],'no face detected'
    if(len(landmarks[1])>1):
        print('multi face detected,use the first')
    return len(faces),faces[0],np.squeeze(landmarks[1][0])

cap = cv2.VideoCapture(0)

while 1:
    ret,img = cap.read()
    # 提取关键点
    facenums,box,points = detect_facepoint(img)
    if(facenums!=0):
        pick_dlib = [19,24,39,36,42,45,33,48,51,54,57,8]
        # 计算朝向
        H,W = img.shape[0],img.shape[1]
        matrix = np.array([[W,0,W/2.0],[0,W,H/2.0],[0,0,1]])
        _,rot_vec,trans_vec = cv2.solvePnP(obj[pick_model,...].astype("float32"),points[pick_dlib,...].astype("float32"),matrix,None,flags=cv2.SOLVEPNP_DLS)
        rot_mat = cv2.Rodrigues(rot_vec)[0]
        pose_mat = cv2.hconcat((rot_mat, trans_vec))
        euler_angle = cv2.decomposeProjectionMatrix(pose_mat)[-1]
        euler_angle = euler_angle.flatten()

        show_img = draw_pick_kps(img.copy(),points,pick_dlib,5)
        show_img = draw_axis(show_img,euler_angle,np.mean(points,axis=0))
        cv2.imshow("img",show_img)
    else:
        cv2.imshow("img",img)
    key = cv2.waitKey(25)
    if key == 27:  # 按键esc
        break

cap.release()
cv2.destroyAllWindows()