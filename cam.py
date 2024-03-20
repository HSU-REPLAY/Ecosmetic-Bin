import cv2
import subprocess

camera=cv2.VideoCapture(0,cv2.CAP_V4L)
ret,image = camera.read()
if ret == True:
	cv2.imwrite('image.jpg',image)
else:
	print('no way')
camera.release()
subprocess.call(["python","ocr.py"])
