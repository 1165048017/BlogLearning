import sys
import os
sys.path.append(os.pardir)

from .utils import try_gpu, set_figsize, show_bboxes
from .models import PNet, RNet, ONet
import math
from PIL import Image
import torchvision.transforms as transforms
import torchvision
import torch.nn.functional as F
import torch


def _no_grad(func):
    def wrapper(*args, **kwargs):
        with torch.no_grad():
            return func(*args, **kwargs)
        
    return wrapper

class FaceDetector():

    def __init__(self):
        self.device = try_gpu()

        # LOAD MODELS
        self.pnet = PNet()
        self.rnet = RNet()
        self.onet = ONet()

        self.pnet.load('./mtcnn/weights/pnet.npy')
        self.rnet.load('./mtcnn/weights/rnet.npy')
        # TBD need to check if weight is on GPU
        self.onet.load('./mtcnn/weights/onet.npy')

    def _preprocess(self, img):
        """Preprocessing step before feeding the network.

        Arguments:
            img {PIL.Image} -- an instance of PIL.Image. 
                            or an image path

        Returns:
            {torch.float32} -- a float tensor of shape [1, C, H, W] in the range [-1.0, 1.0]
        """

        if isinstance(img, str):
            img = Image.open(img)

        # The output of torchvision datasets are PILImage images of range [0, 1]. We transform them to Tensors of normalized range [-1, 1].
        transform = transforms.Compose([
            # Converts a PIL Image or numpy.ndarray (H x W x C) in the range [0, 255] to a torch.FloatTensor of shape (C x H x W) in the range [0.0, 1.0]
            transforms.ToTensor(),
            # Normalize a tensor image with mean and standard deviation
            # input[channel] = (input[channel] - mean[channel]) / std[channel]
            transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
        ])

        img = transform(img).to(self.device)
        img = img.unsqueeze(0)

        return img

    def detect(self, img, min_face_size=20.0, threshold=[0.6, 0.7, 0.8], factor=0.707, nms_threshold=[0.7, 0.7, 0.7]):
        """[summary]

        Arguments:
            img {[type]} -- an instance of PIL.Image.

        Keyword Arguments:
            min_face_size {float} -- a float number. (default: {20.0})
            threshold {list} -- a list of length 3 (default: {[0.6, 0.7, 0.8]})
            factor {float} -- [description] (default: {0.707})
            nms_threshold {list} -- a list of length 3. (default: {[0.7, 0.7, 0.7]})

        Returns:
            [type] -- [description]
        """

        img = self._preprocess(img)

        scales = self.create_image_pyramid(img, min_face_size, factor)

        bounding_boxes = self.stage_one(
            img, scales, threshold[0], nms_threshold[0])
        bounding_boxes = self.stage_two(
            img, bounding_boxes, threshold[1], nms_threshold[1])
        bounding_boxes, _ = self.stage_three(
            img, bounding_boxes, threshold[2], nms_threshold[2])

        return bounding_boxes

    def create_image_pyramid(self, img, min_face_size, factor):
        """BUILD AN IMAGE PYRAMID

        Arguments:
            img {torch.float32} -- a float tensor of shape [1, C, H, W] in the range [-1.0, 1.0]
            min_face_size {float} -- [description]
            factor {float} -- [description]

        Returns:
            {list} -- [description]
        """
        _, _, height, width = img.shape
        min_length = min(height, width)

        min_detection_size = 12

        # scales for scaling the image
        scales = []

        # scales the image so that
        # minimum size that we can detect equals to
        # minimum face size that we want to detect
        m = min_detection_size/min_face_size
        min_length *= m

        factor_count = 0
        while min_length > min_detection_size:
            scales.append(m*factor**factor_count)   # TBD need to optimize here
            min_length *= factor
            factor_count += 1

        return scales

    def _generate_bboxes(self, cls_probs, offsets, scale, threshold):
        """Generate bounding boxes at places

        Arguments:
            cls_probs {[type]} -- a float tensor of shape [1, 2, n, m].
            offsets {[type]} -- a float tensor of shape [1, 4, n, m].
            scale {[type]} -- a float number, 
                width and height of the image were scaled by this number.
            threshold {[type]} -- a float number.

        Returns:
            bounding_boxes {} -- a float tensor of shape [n_boxes, 4]
            scores {} -- a float tensor of shape [n_boxes]
            offsets {} -- a float tensor of shape [n_boxes, 4]
        """

        # applying P-Net is equivalent, in some sense, to
        # moving 12x12 window with stride 2
        stride = 2
        cell_size = 12

        # extract positive probability and resize it as [n, m] dim tensor.
        cls_probs = cls_probs[0, 1, :, :]

        # indices of boxes where there is probably a face
        inds = (cls_probs > threshold).nonzero()

        if inds.shape[0] == 0:
            return torch.empty((0, 4), device=self.device), torch.empty((0), device=self.device), torch.empty((0, 4), device=self.device)

        # transformations of bounding boxes
        tx1, ty1, tx2, ty2 = [
            offsets[0, i, inds[:, 0], inds[:, 1]] for i in range(4)]
        # they are defined as:
        # x1 = x * stride / scale
        # y1 = y * stride / scale
        # x2 = (x * stride + 12) / scale
        # y2 = (y * stride + 12) / scale
        # w = x2 - x1 + 1
        # h = y2 - y1 + 1
        # x1_true = x1 + tx1 * w
        # x2_true = x2 + tx2 * w
        # y1_true = y1 + ty1 * h
        # y2_true = y2 + ty2 * h

        offsets = torch.stack([tx1, ty1, tx2, ty2], dim=1)
        scores = cls_probs[inds[:, 0], inds[:, 1]]

        # P-Net is applied to scaled images
        # so we need to rescale bounding boxes back
        bounding_boxes = torch.stack([
            (stride * inds[:, 1] + 1.0),
            (stride * inds[:, 0] + 1.0),
            (stride * inds[:, 1] + 1.0 + cell_size),
            (stride * inds[:, 0] + 1.0 + cell_size),
        ]).transpose(0, 1).float()
        # why one is added?
        bounding_boxes = bounding_boxes / scale

        return bounding_boxes, scores, offsets

    def _refine_boxes(self, bboxes, height, width):
        bboxes = torch.max(torch.zeros_like(
            bboxes, device=self.device), bboxes)
        sizes = torch.tensor([[width, height, width, height]] *
                             bboxes.shape[0], dtype=torch.float32, device=self.device)
        bboxes = torch.min(bboxes, sizes)

        return bboxes

    def _get_image_boxes(self, bboxes, img, size=24):
        """[summary]

        Arguments:
            bboxes {torch.float32} -- a float tensor of shape [n, 4].
            img {torch.float32} -- a float tensor of shape [1, C, H, W] in the range [-1.0, 1.0]

        Keyword Arguments:
            size {int} -- an integer, size of cutouts. (default: {24})

        Returns:
            {torch.float32} -- a float tensor of shape [n, 3, size, size].
        """

        _, _, height, width = img.shape
        bboxes = self._refine_boxes(bboxes, height, width)

        img_boxes = []

        for box in bboxes:
            im = img[:, :, box[1].int(): box[3].int(),
                     box[0].int(): box[2].int()]
            im = F.interpolate(im, size=(size, size),
                               mode='bilinear', align_corners=False)
            img_boxes.append(im)

        img_boxes = torch.cat(img_boxes, 0)

        return img_boxes

    def _convert_to_square(self, bboxes):
        """Convert bounding boxes to a square form.

        Arguments:
            bboxes {torch.float32} -- a float tensor of shape [n, 4]

        Returns:
            square_bboxes {torch.float32} -- a float tensor of shape [n, 4], 
                squared bounding boxes.  
        """
        square_bboxes = torch.zeros_like(bboxes, device=self.device)
        x1, y1, x2, y2 = [bboxes[:, i] for i in range(4)]
        h = y2 - y1 + 1.0
        w = x2 - x1 + 1.0
        max_side = torch.max(h, w)
        square_bboxes[:, 0] = x1 + w*0.5 - max_side*0.5
        square_bboxes[:, 1] = y1 + h*0.5 - max_side*0.5
        square_bboxes[:, 2] = square_bboxes[:, 0] + max_side - 1.0
        square_bboxes[:, 3] = square_bboxes[:, 1] + max_side - 1.0
        square_bboxes = torch.round(square_bboxes)

        return square_bboxes

    def _calibrate_box(self, bboxes, offsets):
        """Transform bounding boxes to be more like true bounding boxes.
        'offsets' is one of the outputs of the nets.

        Arguments:
            bboxes {torch.float32} -- a float tensor of shape [n, 4].
            offsets {torch.float32} -- a float tensor of shape [n, 4].

        Returns:
            {torch.float32} -- a float tensor of shape [n, 4].
        """
        x1, y1, x2, y2 = [bboxes[:, i] for i in range(4)]
        w = x2 - x1 + 1.0
        h = y2 - y1 + 1.0
        w = torch.unsqueeze(w, 1)
        h = torch.unsqueeze(h, 1)

        # this is what happening here:
        # tx1, ty1, tx2, ty2 = [offsets[:, i] for i in range(4)]
        # x1_true = x1 + tx1 * w
        # y1_true = y1 + ty1 * h
        # x2_true = x2 + tx2 * w
        # y2_true = y2 + ty2 * h
        # below is just more compact form of this

        # are offsets always such that
        # x1 < x2 and y1 < y2 ?
        translation = torch.cat([w, h, w, h], dim=1) * offsets
        bboxes = bboxes + translation

        return bboxes

    @_no_grad
    def stage_one(self, img, scales, threshold, nms_threshold):
        """Run P-Net, generate bounding boxes, and do NMS.

        Arguments:
            img {torch.float32} -- a float tensor of shape [1, C, H, W] in the range [-1.0, 1.0]
            scales {list} -- a float list,
                scale width and height of the image by this number.
            threshold {float} -- a float number,
                threshold on the probability of a face when generating
                bounding boxes from predictions of the net.
            nms_threshold {float} -- [description]

        Returns:
            candidate_boxes {torch.float32} -- a float tensor of shape [n_boxes, 4]
        """

        candidate_boxes = torch.empty((0, 4), device=self.device)
        candidate_scores = torch.empty((0), device=self.device)
        candidate_offsets = torch.empty((0, 4), device=self.device)

        # scale the image
        for scale in scales:
            _, _, height, width = img.shape
            sh, sw = math.ceil(height * scale), math.ceil(width * scale)
            resize_img = F.interpolate(img, size=(
                sh, sw), mode='bilinear', align_corners=False)

            # cls_probs: probability of a face at each sliding window
            # offsets: transformations to true bounding boxes
            cls_probs, offsets = self.pnet(resize_img)

            bboxes, scores, offsets = self._generate_bboxes(
                cls_probs, offsets, scale, threshold)

            candidate_boxes = torch.cat((candidate_boxes, bboxes))
            candidate_scores = torch.cat((candidate_scores, scores))
            candidate_offsets = torch.cat((candidate_offsets, offsets))

        keep = torchvision.ops.nms(
            candidate_boxes, candidate_scores, iou_threshold=nms_threshold)
        candidate_boxes = candidate_boxes[keep]
        candidate_scores = candidate_scores[keep]
        candidate_offsets = candidate_offsets[keep]

        # use offsets predicted by pnet to transform bounding boxes
        candidate_boxes = self._calibrate_box(
            candidate_boxes, candidate_offsets)

        candidate_boxes = self._convert_to_square(candidate_boxes)

        return candidate_boxes

    @_no_grad
    def stage_two(self, img, bboxes, threshold, nms_threshold):
        """Run R-Net, generate bounding boxes, and do NMS.

        Arguments:
            img {torch.float32} -- a float tensor of shape [1, C, H, W] in the range [-1.0, 1.0]
            bboxes {torch.float32} -- [description]
            threshold {float} -- [description]
            nms_threshold {float} -- [description]

        Returns:
            {torch.float32} -- [description]
        """

        # no candidate face found.
        if bboxes.shape[0] == 0:
            return bboxes

        img_boxes = self._get_image_boxes(bboxes, img, size=24)

        cls_probs, offsets = self.rnet(img_boxes)

        scores = cls_probs[:, 1]
        keep = (scores > threshold)
        bboxes = bboxes[keep]
        offsets = offsets[keep]
        scores = scores[keep]

        if bboxes.shape[0] == 0:   # TBD return value need to be check
            return bboxes

        keep = torchvision.ops.nms(bboxes, scores, iou_threshold=nms_threshold)
        bboxes = bboxes[keep]
        offsets = offsets[keep]

        bboxes = self._calibrate_box(bboxes, offsets)
        bboxes = self._convert_to_square(bboxes)

        return bboxes

    @_no_grad
    def stage_three(self, img, bboxes, threshold, nms_threshold):
        """Run O-Net, generate bounding boxes, and do NMS.

        Arguments:
            img {torch.float32} -- a float tensor of shape [1, C, H, W] in the range [-1.0, 1.0]
            bboxes {torch.float32} -- [description]
            threshold {float} -- [description]
            nms_threshold {float} -- [description]

        Returns:
            {torch.float32} -- [description]
        """
        if bboxes.shape[0] == 0:
            return bboxes, torch.empty(0, device=self.device)

        img_boxes = self._get_image_boxes(bboxes, img, size=48)
        cls_probs, offsets, landmarks = self.onet(img_boxes)

        scores = cls_probs[:, 1]
        keep = (scores > threshold)
        bboxes = bboxes[keep]
        offsets = offsets[keep]
        scores = scores[keep]
        landmarks = landmarks[keep]

        if bboxes.shape[0] == 0:
            return bboxes, torch.empty(0, device=self.device)   # TBD

        # compute landmark points
        # TBD

        bboxes = self._calibrate_box(bboxes, offsets)
        keep = torchvision.ops.nms(bboxes, scores, iou_threshold=nms_threshold)
        bboxes = bboxes[keep]
        offsets = offsets[keep]

        return bboxes, torch.empty(0, device=self.device)

if __name__ == '__main__':
    img = Image.open('../assets/office1.jpg')
    detector = FaceDetector()
    bounding_boxes = detector.detect(img)