#!/bin/bash

# Change directory to the location of proces.py
cd /home/osboxes/Documents/GrowthProject

# Run the Python app proces.py
python3 proces.py

# Check if the skeleton/in folder exists
if [ -d "/home/osboxes/Documents/GrowthProject/skeleton/in" ]; then

    # Run the AdTree tool
    ./AdTree-main/Release/bin/AdTree skeleton/in skeleton/out

    # Remove the skeleton/in folder
    rm -rf skeleton/in
else
    echo "skeleton/in folder does not exist. Skipping AdTree command."
fi

# Check if the skeleton/out folder exists and is not empty
if [ -d "/home/osboxes/Documents/GrowthProject/skeleton/out" ] && [ "$(ls -A /home/osboxes/Documents/GrowthProject/skeleton/out)" ]; then
    # Remove the whole /tmp/processing folder
    rm -rf /tmp/processing

    # Make the /tmp/processing folder
    mkdir /tmp/processing

    # Change directory to the location of processing-java script
    cd /home/osboxes/Downloads/processing-4.3

    # Run another script using processing-java command
    ./processing-java --sketch=/home/osboxes/Downloads/viewer3/viewer --present
else
    echo "skeleton/out folder does not exist or is empty. Skipping processing-java command."
fi
