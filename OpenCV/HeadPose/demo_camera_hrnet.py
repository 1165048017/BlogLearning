import cv2
import numpy as np

from mtcnn.src.detect import FaceDetector
from HRNetFace.utils_inference import get_lmks_by_img, get_model_by_name
from HRNetFace.pose_estimator import PoseEstimator

detector = FaceDetector()
model = get_model_by_name('300W', device='cuda')

capture = cv2.VideoCapture(0)  #"./image/testface1.mp4"
headpose_estimator = PoseEstimator(img_size=(capture.get(cv2.CAP_PROP_FRAME_HEIGHT),capture.get(cv2.CAP_PROP_FRAME_WIDTH)))

obj, index = np.load("./model/head_pose_object_points.npy", allow_pickle=True)
obj = obj.T *10
obj[...,1] = -obj[...,1]
obj[...,0] = obj[...,0] - obj[...,0].min()+10
obj[...,1] = obj[...,1] - obj[...,1].min()+10

pick_model = [7,2, 22,18, 14,10,  30, 34,35,36,37,38]

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

while(capture.isOpened()):
    ret,img = capture.read()
    bboxes = detector.detect(img) 
    if(len(bboxes)>=1):
        bbox = bboxes[0].cpu().numpy()
        bbox_height = bbox[2] - bbox[0]
        bbox[0] = max(0,bbox[0]-bbox_height/3)
        bbox[2] = min(bbox[2]+bbox_height/3,img.shape[1])
        bbox_width = bbox[3] - bbox[1]
        bbox[1] = max(0,bbox[1] - bbox_width/4)
        bbox[3] = min(bbox[3] + bbox_width/4,img.shape[0])
        bbox = [int(bbox[1]),int(bbox[0]),int(bbox[3]),int(bbox[2])]
    else:
        bbox = [0,0,img.shape[0],img.shape[1]]
    face_img = img[bbox[0]:bbox[2],bbox[1]:bbox[3]]    
    lmks = get_lmks_by_img(model, face_img) 
    face_kps = []
    for kps in lmks:
        face_kps.append([int(bbox[1]+kps[0]),int(bbox[0]+kps[1])])
    points = np.array(face_kps,dtype=np.float32)

    pick_dlib = [19,24,39,36,42,45,33,48,51,54,57,8]
    # 计算朝向
    H,W = img.shape[0],img.shape[1]
    matrix = np.array([[W,0,W/2.0],[0,W,H/2.0],[0,0,1]])
    _,rot_vec,trans_vec = cv2.solvePnP(obj[pick_model,...].astype("float32"),points[pick_dlib,...].astype("float32"),matrix,None)
    # rot_vec,trans_vec = headpose_estimator.solve_pose_by_68_points(points)
    rot_mat = cv2.Rodrigues(rot_vec)[0]
    pose_mat = cv2.hconcat((rot_mat, trans_vec))
    euler_angle = cv2.decomposeProjectionMatrix(pose_mat)[-1]
    euler_angle = euler_angle.flatten()

    show_img = draw_pick_kps(img.copy(),points,pick_dlib,5)
    show_img = draw_axis(show_img,euler_angle,np.mean(points,axis=0))
    cv2.imshow("img",show_img)
    key = cv2.waitKey(25)
    if key == 27:  # 按键esc
        break

cap.release()
cv2.destroyAllWindows()