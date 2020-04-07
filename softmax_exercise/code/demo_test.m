%% test softmax
clear
clc
close all

load softmaxModel.mat

img=imread('./testimg/9.png');
test_input=double(reshape(img,[784,1])/255.0);

[pred] = softmaxPredict(softmaxModel, test_input);

imshow(img)
title(pred)