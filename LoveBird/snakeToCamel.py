import os
import re

# Snake case를 camelCase로 변환하는 함수
def snake_to_camel(word):
    components = word.split('_')
    return components[0] + ''.join(x.capitalize() for x in components[1:])

# 현재 디렉토리의 모든 .swift 파일을 찾기
for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".swift"):
            file_path = os.path.join(root, file)
            
            # 파일 읽기
            with open(file_path, 'r') as f:
                content = f.read()
                
                # 패턴에 맞는 문자열 찾아서 바꾸기
                content = re.sub(r'Color\(R.color.(\w+)\)', lambda m: "LoveBirdAsset." + snake_to_camel(m.group(1)) + ".swiftUIColor", content)
                content = re.sub(r'Image\(R.image.(\w+)\)', lambda m: "LoveBirdAsset." + snake_to_camel(m.group(1)) + ".swiftUIImage", content)
                content = re.sub(r'String\(resource: R.string.localizable.(\w+)\)', lambda m: "LoveBirdStrings." + snake_to_camel(m.group(1)), content)
                content = re.sub(r'Text\(R.string.localizable.(\w+)\)', lambda m: "Text(LoveBirdStrings." + snake_to_camel(m.group(1)) + ")", content)
            
            # 변경된 내용을 다시 파일에 쓰기
            with open(file_path, 'w') as f:
                f.write(content)
