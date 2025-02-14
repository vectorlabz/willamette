import re
import glob


def remove_think_sections(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Remove everything between <think> and </think>, including the tags
    cleaned_content = re.sub(r'<think>.*?</think>', '', content, flags=re.DOTALL)
    
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(cleaned_content)

for file in glob.glob("*.md"):
    remove_think_sections(file)
