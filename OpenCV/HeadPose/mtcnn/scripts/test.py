import numpy as np

weights = np.load('./pnet.npy', encoding='bytes', allow_pickle=True)[()]
doc = open('pnet.txt', 'a')
print(weights, file=doc)