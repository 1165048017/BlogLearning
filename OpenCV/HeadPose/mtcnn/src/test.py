#!/usr/bin/env python
import sys
import os
sys.path.append(os.pardir)
from importlib import import_module
import cv2
from src.detect import FaceDetector

# import camera driver
if os.environ.get('CAMERA'):
    Camera = import_module('camera_' + os.environ['CAMERA']).Camera
else:
    from camera import Camera


if __name__ == "__main__":
    detector = FaceDetector()
    
    while True:
        frame = Camera().get_frame()
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)        
        bounding_boxes = detector.detect(image)

        for i in range(len(bounding_boxes)):
            cv2.rectangle(frame, (int(bounding_boxes[i][0]), int(bounding_boxes[i][1])),
                         (int(bounding_boxes[i][2]), int(bounding_boxes[i][3])), (255, 0, 0), 2)

        cv2.imshow('capture', frame)
        key = cv2.waitKey(1)
        if key & 0xFF == ord('q'):
            break