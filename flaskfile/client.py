import requests
import argparse
import base64
import cv2
import numpy as np
import os

# Initialize the keras REST API endpoint URL.
REST_API_URL = 'http://192.168.3.10:5555/upload'

def upload_file(file_path):
    file_bin = open(file_path,'rb').read()
    upload_content = {"myfile":file_bin}
    upload_name = {"name":os.path.basename(file_path)}
    r = requests.post(REST_API_URL,data=upload_name,files=upload_content).json()
    if(r['succeed']):
        print("success")
    else:
        print("failed")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Classification demo')
    parser.add_argument('--file', type=str, help='file path')

    args = parser.parse_args()
    upload_file(args.file)