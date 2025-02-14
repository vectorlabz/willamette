#!/bin/bash

# Start timer
START_TIME=$(date +%s)

# Get macOS version
macOS=$(defaults read /System/Library/CoreServices/SystemVersion.plist ProductName)
macOS_version=$(sw_vers -productVersion)

# Select and define your model from https://ollama.com/search
# model:parameters
MODEL="deepseek-r1:1.5b"

# Function to get GPU name on macOS
get_gpu_name() {
    GPU_NAME=$(system_profiler SPDisplaysDataType | grep "Chipset Model" | awk -F ': ' '{print $2}' | head -n1)
    if [ -z "$GPU_NAME" ]; then
        GPU_NAME="Unknown GPU"
    fi
    echo $GPU_NAME
}


# Display macOS version
echo " Apple $macOS $macOS_version | Willamette 25.2.14 | Telegram: @i986ninja"

# Show GPU name
GPU_NAME=$(get_gpu_name)
echo "🔹 GPU: $GPU_NAME"
echo "🔹 GPU::Init()"

echo "🔹 Running $MODEL"

# Extract title from message.txt
TITLE=$(head -n1 message.txt | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/^_\|_$//g')
echo "✅ Title extracted"

echo "🔹 Processing message with Ollama..."
echo "🔹 Thinking..."
(cat message.txt | ollama run --verbose $MODEL | tee "${TITLE}.md" | perl -0777 -pe 's/<think>.*?<\/think>//sg')

# Run Python script in the background
python ninja.py &

# End timer and calculate elapsed time
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

# Format time into minutes and seconds
if [ $ELAPSED_TIME -lt 60 ]; then
    echo "✅ Done in ${ELAPSED_TIME} seconds"
else
    MINUTES=$((ELAPSED_TIME / 60))
    SECONDS=$((ELAPSED_TIME % 60))
    echo "✅ Done in ${MINUTES} minutes and ${SECONDS} seconds"
fi
