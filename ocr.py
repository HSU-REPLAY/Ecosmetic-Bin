import pytesseract
from PIL import Image

image_path = '/home/pi/project/image.jpg'  #이미지 경로
image = Image.open(image_path)
my_config = "-l eng+kor --oem 3 --psm 6"  #한글,영어 인식가능

text = pytesseract.image_to_string(image, config=my_config)

print(text)
tokens = text.split()

plastic_cnt=0
can_cnt=0
glass_cnt=0

for token in tokens:
    if "Plastic" in token:
        plastic_cnt += 1
    elif "Can" in token:
        can_cnt += 1
    elif "Glass" in token:
        glass_cnt += 1

print("Plastic count:", plastic_cnt)
print("Can count:", can_cnt)
print("Glass count:", glass_cnt)
