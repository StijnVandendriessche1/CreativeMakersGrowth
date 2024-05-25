# Automation Script for GrowthProject (run.sh)

This script automates a series of tasks related to the GrowthProject. It runs a Python application, executes a tool, manages temporary directories, and runs a processing script based on certain conditions.

## Script Details

The script performs the following actions:
1. Changes directory to the location of the Python application and runs `proces.py`.
2. Checks if the `skeleton/in` folder exists:
   - If it exists, it runs the AdTree tool with specific inputs and outputs, then removes the `skeleton/in` folder.
   - If it does not exist, it skips the AdTree command.
3. Checks if the `skeleton/out` folder exists and is not empty:
   - If it exists and is not empty, it removes and recreates the `/tmp/processing` folder, then runs the `processing-java` command.
   - If it does not exist or is empty, it skips the `processing-java` command.

## Usage

1. Ensure that you have the necessary permissions to execute the script:
    ```bash
    chmod +x run.sh
    ```

2. Run the script:
    ```bash
    ./run.sh
    ```

## Directory Structure

- `/home/osboxes/Documents/GrowthProject`:
  - Contains the `proces.py` Python application.
  - Contains the `AdTree-main/Release/bin/AdTree` directory with the `skeleton` subdirectory.

- `/home/osboxes/Downloads/processing-4.3`:
  - Contains the `processing-java` executable.

- `/home/osboxes/Downloads/viewer3`:
  - Contains the `viewer` sketch.

## Prerequisites

- Ensure that Python is installed and properly configured.
- The AdTree tool should be compiled and located in the specified directory.
- The Processing 4.3 software should be installed and accessible at the specified path.

## Notes

- Adjust the paths in the script if your directory structure differs.
- Ensure all required files and directories exist before running the script.
- The script will skip certain steps if conditions are not met (e.g., if specific directories do not exist).
- The first time the script is ran it will only create the required directories. Paste the scan files in in/todo and run the script again and the files will get processed and displayed.

## Troubleshooting

- If the script does not execute properly, check the paths and permissions.
- Ensure all necessary dependencies and software are installed.
- Review the echo messages for skipped steps to understand why certain commands were not executed.
