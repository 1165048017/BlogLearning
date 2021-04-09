import caffe
import numpy as np
import torch

"""
# PNet
# conv1.weight (10, 3, 3, 3)
# conv1.bias (10,)
# prelu1.weight (10,)
# conv2.weight (16, 10, 3, 3)
# conv2.bias (16,)
# prelu2.weight (16,)
# conv3.weight (32, 16, 3, 3)
# conv3.bias (32,)
# prelu3.weight (32,)
# conv4-1.weight (2, 32, 1, 1)
# conv4-1.bias (2,)
# conv4-2.weight (4, 32, 1, 1)
# conv4-2.bias (4,)

# RNet
# conv1.weight (28, 3, 3, 3)
# conv1.bias (28,)
# prelu1.weight (28,)
# conv2.weight (48, 28, 3, 3)
# conv2.bias (48,)
# prelu2.weight (48,)
# conv3.weight (64, 48, 2, 2)
# conv3.bias (64,)
# prelu3.weight (64,)
# conv4.weight (128, 576)
# conv4.bias (128,)
# prelu4.weight (128,)
# conv5-1.weight (2, 128)
# conv5-1.bias (2,)
# conv5-2.weight (4, 128)
# conv5-2.bias (4,)

# ONet
# conv1.weight (32, 3, 3, 3)
# conv1.bias (32,)
# prelu1.weight (32,)
# conv2.weight (64, 32, 3, 3)
# conv2.bias (64,)
# prelu2.weight (64,)
# conv3.weight (64, 64, 3, 3)
# conv3.bias (64,)
# prelu3.weight (64,)
# conv4.weight (128, 64, 2, 2)
# conv4.bias (128,)
# prelu4.weight (128,)
# conv5.weight (256, 1152)
# conv5.bias (256,)
# prelu5.weight (256,)
# conv6-1.weight (2, 256)
# conv6-1.bias (2,)
# conv6-2.weight (4, 256)
# conv6-2.bias (4,)
# conv6-3.weight (10, 256)
# conv6-3.bias (10,)
"""

def dump_layer(net):
    for param in net.params.keys():
        print(param.lower() + '.weight', net.params[param][0].data.shape)
        if len(net.params[param]) == 2:
            print(param.lower() + '.bias', net.params[param][1].data.shape)

def convert_to_pytorch_model(net, **net_info):
    model_state = {}

    for param in net.params.keys(): 
        if  net_info['cls_prob'] in param:
            prefix = 'cls_prob.' + param.lower().replace('-', '_')
        elif net_info['bbox_offset'] in param:
            prefix = 'bbox_offset.' + param.lower().replace('-', '_')
        elif net_info['landmarks'] is not None and net_info['landmarks'] in param:
            prefix = 'landmarks.' + param.lower().replace('-', '_')
        else:
            prefix = 'backend.' + param.lower()

        if 'prelu' in prefix:
            model_state[prefix + '.weight'] = torch.tensor(net.params[param][0].data)
        else:
            if len(net.params[param][0].data.shape) == 4:
                model_state[prefix + '.weight'] = torch.tensor(net.params[param][0].data.transpose((0, 1, 3, 2)))
            else:
                model_state[prefix + '.weight'] = torch.tensor(net.params[param][0].data)
            
            model_state[prefix + '.bias'] = torch.tensor(net.params[param][1].data)

    return model_state


def covnver_pnet():
    net = caffe.Net('../caffe_models/det1.prototxt', '../caffe_models/det1.caffemodel', caffe.TEST)
    # dump_layer(net)
    p = convert_to_pytorch_model(net, cls_prob='conv4-1', bbox_offset='conv4-2', landmarks=None)
    np.save('pnet.npy', p, allow_pickle=True)

def covnver_rnet():
    net = caffe.Net('../caffe_models/det2.prototxt', '../caffe_models/det2.caffemodel', caffe.TEST)
    # dump_layer(net)
    p = convert_to_pytorch_model(net, cls_prob='conv5-1', bbox_offset='conv5-2', landmarks=None)
    np.save('rnet.npy', p, allow_pickle=True)

def covnver_onet():
    net = caffe.Net('../caffe_models/det3.prototxt', '../caffe_models/det3.caffemodel', caffe.TEST)
    # dump_layer(net)
    p = convert_to_pytorch_model(net, cls_prob='conv6-1', bbox_offset='conv6-2', landmarks='conv6-3')
    np.save('onet.npy', p, allow_pickle=True)

if __name__ == "__main__":
    covnver_pnet()
    covnver_rnet()
    covnver_onet()
