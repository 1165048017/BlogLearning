import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from collections import OrderedDict
from .utils import try_gpu


class Flatten(nn.Module):
    def __init__(self):
        super(Flatten, self).__init__()

    def forward(self, x):
        """[summary]

        Arguments:
            x {[type]} -- a float tensor with shape [batch_size, c, h, w].

        Returns:
            [type] -- a float tensor with shape [batch_size, c*h*w].
        """

        # without this pretrained model isn't working
        x = x.transpose(3, 2).contiguous()

        # "flatten" the C * H * W values into a single vector per image
        return x.view(x.size(0), -1)


class _Net(nn.Module):
    def __init__(self, is_training=False, device=try_gpu()):
        super(_Net, self).__init__()

        self._init_net()

        # Move tensor to target device
        self.to(device)

        self.train(is_training)

    def _init_net(self):
        raise NotImplementedError

    def load(self, model_path):
        states_to_load = np.load(model_path, allow_pickle=True)[()]
        model_state = self.state_dict()
        model_state.update(states_to_load)
        self.load_state_dict(model_state)


class PNet(_Net):
    """
    Model's state_dict:
    backend.conv1.weight     torch.Size([10, 3, 3, 3])
    backend.conv1.bias       torch.Size([10])
    backend.prelu1.weight    torch.Size([10])
    backend.conv2.weight     torch.Size([16, 10, 3, 3])
    backend.conv2.bias       torch.Size([16])
    backend.prelu2.weight    torch.Size([16])
    backend.conv3.weight     torch.Size([32, 16, 3, 3])
    backend.conv3.bias       torch.Size([32])
    backend.prelu3.weight    torch.Size([32])
    cls_prob.conv4_1.weight          torch.Size([2, 32, 1, 1])
    cls_prob.conv4_1.bias    torch.Size([2])
    bbox_offset.conv4_2.weight       torch.Size([4, 32, 1, 1])
    bbox_offset.conv4_2.bias         torch.Size([4])
    """

    def __init__(self, **kwargs):
        super(PNet, self).__init__(**kwargs)

    def _init_net(self):
        self.backend = nn.Sequential(OrderedDict([
            ('conv1', nn.Conv2d(3, 10, kernel_size=3, stride=1)),
            ('prelu1', nn.PReLU(10)),
            ('pool1', nn.MaxPool2d(kernel_size=2, stride=2, ceil_mode=True)),

            ('conv2', nn.Conv2d(10, 16, kernel_size=3, stride=1)),
            ('prelu2', nn.PReLU(16)),

            ('conv3', nn.Conv2d(16, 32, kernel_size=3, stride=1)),
            ('prelu3', nn.PReLU(32))
        ]))

        self.cls_prob = nn.Sequential(OrderedDict([
            ('conv4_1', nn.Conv2d(32, 2, 1, 1)),
            ('softmax', nn.Softmax(dim=1))
        ]))

        self.bbox_offset = nn.Sequential(OrderedDict([
            ('conv4_2', nn.Conv2d(32, 4, 1, 1))
        ]))

    def forward(self, x):
        """[summary]

        Arguments:
            x {torch.float32} -- a float tensor with shape [batch_size, 3, h, w].

        Returns:
            cls_probs {torch.float32} -- a float tensor with shape [batch_size, 2, h, w].
            offsets {torch.float32} -- a float tensor with shape [batch_size, 4, h, w].
        """

        feature_map = self.backend(x)

        # face classification
        cls_probs = self.cls_prob(feature_map)

        # bounding box regression
        offsets = self.bbox_offset(feature_map)

        return cls_probs, offsets


class RNet(_Net):
    """
    Model's state_dict:
    backend.conv1.weight     torch.Size([28, 3, 3, 3])
    backend.conv1.bias       torch.Size([28])
    backend.prelu1.weight    torch.Size([28])
    backend.conv2.weight     torch.Size([48, 28, 3, 3])
    backend.conv2.bias       torch.Size([48])
    backend.prelu2.weight    torch.Size([48])
    backend.conv3.weight     torch.Size([64, 48, 2, 2])
    backend.conv3.bias       torch.Size([64])
    backend.prelu3.weight    torch.Size([64])
    backend.conv4.weight     torch.Size([128, 576])
    backend.conv4.bias       torch.Size([128])
    backend.prelu4.weight    torch.Size([128])
    cls_prob.conv5_1.weight          torch.Size([2, 128])
    cls_prob.conv5_1.bias    torch.Size([2])
    bbox_offset.conv5_2.weight       torch.Size([4, 128])
    bbox_offset.conv5_2.bias         torch.Size([4])
    """

    def __init__(self, **kwargs):
        super(RNet, self).__init__(**kwargs)

    def _init_net(self):
        self.backend = nn.Sequential(OrderedDict([
            ('conv1', nn.Conv2d(3, 28, 3, 1)),
            ('prelu1', nn.PReLU(28)),
            ('pool1', nn.MaxPool2d(3, 2, ceil_mode=True)),

            ('conv2', nn.Conv2d(28, 48, 3, 1)),
            ('prelu2', nn.PReLU(48)),
            ('pool2', nn.MaxPool2d(3, 2, ceil_mode=True)),

            ('conv3', nn.Conv2d(48, 64, 2, 1)),
            ('prelu3', nn.PReLU(64)),

            ('flatten', Flatten()),
            # Linear(in_features, out_features, bias=True)
            ('conv4', nn.Linear(576, 128)),
            ('prelu4', nn.PReLU(128))
        ]))

        self.cls_prob = nn.Sequential(OrderedDict([
            ('conv5_1', nn.Linear(128, 2)),
            ('softmax', nn.Softmax(dim=1))
        ]))

        self.bbox_offset = nn.Sequential(OrderedDict([
            ('conv5_2', nn.Linear(128, 4))
        ]))

    def forward(self, x):
        """[summary]

        Arguments:
            x {torch.float32} -- a float tensor with shape [batch_size, 3, h, w].

        Returns:
            cls_probs {torch.float32} -- a float tensor with shape [batch_size, 2].
            offsets {torch.float32} -- a float tensor with shape [batch_size, 4].
        """

        feature_map = self.backend(x)

        # face classification
        cls_probs = self.cls_prob(feature_map)

        # bounding box regression
        offsets = self.bbox_offset(feature_map)

        return cls_probs, offsets


class ONet(_Net):
    """
    Model's state_dict:
    backend.conv1.weight     torch.Size([32, 3, 3, 3])
    backend.conv1.bias       torch.Size([32])
    backend.prelu1.weight    torch.Size([32])
    backend.conv2.weight     torch.Size([64, 32, 3, 3])
    backend.conv2.bias       torch.Size([64])
    backend.prelu2.weight    torch.Size([64])
    backend.conv3.weight     torch.Size([64, 64, 3, 3])
    backend.conv3.bias       torch.Size([64])
    backend.prelu3.weight    torch.Size([64])
    backend.conv4.weight     torch.Size([128, 64, 2, 2])
    backend.conv4.bias       torch.Size([128])
    backend.prelu4.weight    torch.Size([128])
    backend.conv5.weight     torch.Size([256, 1152])
    backend.conv5.bias       torch.Size([256])
    backend.prelu5.weight    torch.Size([256])
    cls_prob.conv6_1.weight          torch.Size([2, 256])
    cls_prob.conv6_1.bias    torch.Size([2])
    bbox_offset.conv6_2.weight       torch.Size([4, 256])
    bbox_offset.conv6_2.bias         torch.Size([4])
    landmarks.conv6_3.weight         torch.Size([10, 256])
    landmarks.conv6_3.bias   torch.Size([10])
    """

    def __init__(self, **kwargs):
        super(ONet, self).__init__(**kwargs)

    def _init_net(self):
        self.backend = nn.Sequential(OrderedDict([
            ('conv1', nn.Conv2d(3, 32, 3, 1)),
            ('prelu1', nn.PReLU(32)),
            ('pool1', nn.MaxPool2d(3, 2, ceil_mode=True)),

            ('conv2', nn.Conv2d(32, 64, 3, 1)),
            ('prelu2', nn.PReLU(64)),
            ('pool2', nn.MaxPool2d(3, 2, ceil_mode=True)),

            ('conv3', nn.Conv2d(64, 64, 3, 1)),
            ('prelu3', nn.PReLU(64)),
            ('pool3', nn.MaxPool2d(2, 2, ceil_mode=True)),

            ('conv4', nn.Conv2d(64, 128, 2, 1)),
            ('prelu4', nn.PReLU(128)),

            ('flatten', Flatten()),
            ('conv5', nn.Linear(1152, 256)),
            ('drop5', nn.Dropout(0.25)),
            ('prelu5', nn.PReLU(256))
        ]))

        self.cls_prob = nn.Sequential(OrderedDict([
            ('conv6_1', nn.Linear(256, 2)),
            ('softmax', nn.Softmax(dim=1))
        ]))

        self.bbox_offset = nn.Sequential(OrderedDict([
            ('conv6_2', nn.Linear(256, 4))
        ]))

        self.landmarks = nn.Sequential(OrderedDict([
            ('conv6_3', nn.Linear(256, 10))
        ]))

    def forward(self, x):
        """[summary]

        Arguments:
            x {torch.float32} -- a float tensor with shape [batch_size, 3, h, w].

        Returns:
            cls_probs {torch.float32} -- a float tensor with shape [batch_size, 2].
            offsets {torch.float32} -- a float tensor with shape [batch_size, 4].
            landmarks {torch.float32} -- a float tensor with shape [batch_size, 10].
        """

        feature_map = self.backend(x)

        # face classification
        cls_probs = self.cls_prob(feature_map)

        # bounding box regression
        offsets = self.bbox_offset(feature_map)

        # Ficial landmark localization
        landmarks = self.landmarks(feature_map)

        return cls_probs, offsets, landmarks
