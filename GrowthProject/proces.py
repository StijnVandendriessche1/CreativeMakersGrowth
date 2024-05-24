import os
import numpy as np
from sklearn.cluster import DBSCAN


def ensure_directories():
    directories = ['in', 'out', 'skeleton', 'in/todo', 'in/done', 'skeleton/in', 'skeleton/out']
    for directory in directories:
        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"Created directory: {directory}")


def process_files():
    todo_path = 'in/todo'
    done_path = 'in/done'

    if not os.path.exists(todo_path):
        print(f"Directory does not exist: {todo_path}")
        return

    files = [f for f in os.listdir(todo_path) if os.path.isfile(os.path.join(todo_path, f))]
    if not files:
        print("No files to process. Shutting down.")
        return

    for filename in files:
        file_path = os.path.join(todo_path, filename)
        done_file_path = os.path.join(done_path, filename)

        if os.path.exists(done_file_path):
            print(f"File already exists in 'done' directory: {filename}. Skipping file.")
            continue

        print(f"Processing file: {filename}")
        process_file(file_path, filename)
        move_to_done(file_path, done_file_path)


def process_file(file_path, filename):
    coordinates = []
    with open(file_path, 'r') as file:
        for i, line in enumerate(file):
            if i % 1500 == 0:
                parts = line.split()
                if len(parts) >= 3:
                    x, y, z = map(float, parts[:3])
                    if z >= 7:
                        coordinates.append([x, y, z])

    if coordinates:
        coordinates = np.array(coordinates)
        filtered_coordinates = remove_outliers(coordinates, eps=0.75, min_samples=1)
        print(f"Original count: {len(coordinates)}, Filtered count: {len(filtered_coordinates)}")

        translated_coordinates = translate_to_origin(filtered_coordinates)

        plant_name, date = extract_plant_name_and_date(filename)
        output_filename = f"{plant_name}_{date}_reduced.xyz"

        export_processed_file_to_out(translated_coordinates, output_filename)
        export_processed_file_to_skeleton(translated_coordinates, output_filename)


def remove_outliers(coordinates, eps=0.75, min_samples=1):
    db = DBSCAN(eps=eps, min_samples=min_samples).fit(coordinates)
    is_core = np.zeros_like(db.labels_, dtype=bool)
    is_core[db.core_sample_indices_] = True
    return coordinates[is_core]


def translate_to_origin(coordinates):
    min_z_index = np.argmin(coordinates[:, 2])
    min_point = coordinates[min_z_index]
    translated_coordinates = coordinates - min_point
    return translated_coordinates


def export_processed_file_to_out(filtered_coordinates, output_filename):
    out_subdir = os.path.join('out', output_filename.split('_')[0])

    if not os.path.exists(out_subdir):
        os.makedirs(out_subdir)
        print(f"Created directory: {out_subdir}")

    output_path = os.path.join(out_subdir, output_filename)

    np.savetxt(output_path, filtered_coordinates, fmt='%f %f %f')
    print(f"Exported processed file to: {output_path}")


def export_processed_file_to_skeleton(translated_coordinates, output_filename):
    skeleton_in_dir = 'skeleton/in'
    skeleton_path = os.path.join(skeleton_in_dir, output_filename)

    np.savetxt(skeleton_path, translated_coordinates, fmt='%f %f %f')
    print(f"Exported processed file to skeleton/in: {skeleton_path}")


def move_to_done(file_path, done_file_path):
    try:
        os.rename(file_path, done_file_path)
        print(f"Moved file to done: {done_file_path}")
    except FileExistsError:
        print(f"File already exists in 'done' directory: {done_file_path}. Not moving file.")


def extract_plant_name_and_date(filename):
    parts = filename.split('_')
    if len(parts) >= 2:
        return parts[0], parts[1]
    return "", ""


def main():
    ensure_directories()
    process_files()


if __name__ == "__main__":
    main()
