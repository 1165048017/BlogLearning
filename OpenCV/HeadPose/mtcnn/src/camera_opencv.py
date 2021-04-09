import cv2
from base_camera import BaseCamera


class Camera(BaseCamera):
    video_source = 0
    cap = None

    @staticmethod
    def set_video_source(source):
        Camera.video_source = source

    @staticmethod
    def frames():
        Camera.cap = cv2.VideoCapture(Camera.video_source)
        if not Camera.cap.isOpened():
            raise RuntimeError('Could not start camera.')

        while True:
            # read current frame
            _, img = Camera.cap.read()

            # encode as a jpeg image and return it
            # yield cv2.imencode('.jpg', img)[1].tobytes()
            yield img

    @staticmethod
    def close():
        print('1release camera resource')
        if Camera.cap:
            print('2release camera resource')
            Camera.cap.release()