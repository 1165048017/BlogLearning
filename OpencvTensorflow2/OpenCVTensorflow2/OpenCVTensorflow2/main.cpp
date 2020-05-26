//
//  main.cpp
//  OpenCVTensorflow2
//
//  Created by 周兵 on 2020/5/26.
//  Copyright © 2020 周兵. All rights reserved.
//

#include <iostream>
#include "opencv2/opencv.hpp"
using namespace cv;
using namespace std;

void InitMat(Mat& m,float* num)
{
 for(int i=0;i<m.rows;i++)
  for(int j=0;j<m.cols;j++)
   m.at<float>(i,j)=*(num+i*m.rows+j);
}

int main(int argc, const char * argv[]) {
    dnn::Net net = dnn::readNetFromTensorflow("/Users/bingo/Documents/code/BlogLearning/OpencvTensorflow2/frozen_models/frozen_graph.pb");
    float sz[] = {1,1,1,1};
    Mat input(1,4,CV_32F);
    InitMat(input, sz);
    net.setInput(input);
    Mat pred = net.forward();
    cout<<pred<<endl;
    return 0;
}
