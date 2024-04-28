import pytesseract
from PIL import Image

plastic_cnt = 0
can_cnt = 0
glass_cnt = 0

def ocr(image_path):
    global plastic_cnt, can_cnt, glass_cnt
    plastic_cnt = 0
    can_cnt = 0
    glass_cnt = 0
    image = Image.open(image_path)
    my_config = "-l eng --oem 3 --psm 6" # 영어만 인식 가능

    text = pytesseract.image_to_string(image, config=my_config)
    print(text)

    tokens = text.split()

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

def getCnt():
    return str(plastic_cnt) + "," + str(can_cnt) + "," + str(glass_cnt)  # plastic_cnt, can_cnt, glass_cnt을 문자열로 반환

