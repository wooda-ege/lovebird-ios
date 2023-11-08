import os

def replace_in_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        content = content.replace('ReducerProtocol', 'Reducer')
        content = content.replace('ReducerProtocolOf', 'ReducerOf')

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    current_directory = os.getcwd()  # 현재 디렉토리 가져오기

    for subdir, _, files in os.walk(current_directory):
        for file in files:
            if file.endswith('.swift'):
                file_path = os.path.join(subdir, file)
                replace_in_file(file_path)

    print("Replacement done!")

if __name__ == "__main__":
    main()
