# Point Cloud Processor

This Python program processes point cloud data files, filtering and translating coordinates based on specific criteria, and then exports the results to specified directories. The program is designed to create necessary directory structures, process the files, and handle file naming to avoid conflicts.

## Features

- Automatically creates necessary directories if they do not exist.
- Processes files in the `in/todo` directory.
- Filters out points with `z < 7`.
- Reads one line in every 1500 from the input files for processing.
- Removes outliers using DBSCAN clustering.
- Translates points so that the point with the lowest `z` value is at the origin.
- Exports processed files to the `out` and `skeleton/in` directories.
- Moves processed files to the `in/done` directory to avoid reprocessing.

## Prerequisites

- Python 3.x
- NumPy
- scikit-learn

You can install the required Python packages using:

```bash
pip install numpy scikit-learn
