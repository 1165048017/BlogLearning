# coding: utf-8

from IPython import display
import matplotlib.pyplot as plt
import torch
from PIL import ImageDraw


def use_svg_display():
    """用矢量图显示
    """

    display.set_matplotlib_formats('svg')


def set_figsize(figsize=(3.5, 2.5)):
    """Set matplotlib figure size.

    Keyword Arguments:
        figsize {tuple} -- [description] (default: {(3.5, 2.5)})
    """

    use_svg_display()
    plt.rcParams['figure.figsize'] = figsize


def try_gpu():
    use_cuda = torch.cuda.is_available()
    return torch.device("cuda" if use_cuda else "cpu")


def show_bboxes(img, bboxes, facial_landmarks=[]):
    """Draw bounding boxes and facial landmarks.

    Arguments:
        img {[type]} -- an instance of PIL.Image.
        bboxes {[type]} -- a float numpy array of shape [n, 5].

    Keyword Arguments:
        facial_landmarks {list} -- a float numpy array of shape [n, 10]. (default: {[]})

    Returns:
        [type] -- an instance of PIL.Image.
    """

    img_copy = img.copy()
    draw = ImageDraw.Draw(img_copy)

    for b in bboxes:
        draw.rectangle([
            (b[0], b[1]), (b[2], b[3])
        ], outline='white')

    for p in facial_landmarks:
        for i in range(5):
            draw.ellipse([
                (p[i] - 1.0, p[i + 5] - 1.0),
                (p[i] + 1.0, p[i + 5] + 1.0)
            ], outline='blue')

    return img_copy
