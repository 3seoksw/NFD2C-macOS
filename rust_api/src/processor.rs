use std::fs;
use std::path::Path;
use unicode_normalization::UnicodeNormalization;
use walkdir::WalkDir;

pub fn process_file(file_path: &Path, verbose: bool) -> String {
    let mut result_file_path = String::new();

    let path = file_path;
    if !file_path.is_file() {
        eprintln!("No such file found: {:?}", file_path);
        return result_file_path;
    }


    if let Some(parent) = path.parent() {
        let file_name_str = path.file_name().unwrap();
        let file_name = file_name_str.to_string_lossy();

        if file_name == ".DS_Store" {
            return result_file_path;
        }

        let normalized_name: String = file_name.nfc().collect();

        if file_name != normalized_name {
            let new_path = parent.join(&normalized_name);

            match fs::rename(&path, &new_path) {
                Ok(_) => {
                    println!("[x] {:?}", new_path);
                    result_file_path = new_path.to_string_lossy().to_string();
                    return result_file_path;
                }
                Err(e) => {
                    eprintln!("[ ] {:?}\n └─ Error: {}", path, e);
                }
            }
        } else if verbose {
            println!("[ ] {:?}\n └─ NFC format already satisfied", file_path);
        }
    }
    return result_file_path;
}

pub fn process_directory(dir: &str, recursive: bool, verbose: bool) -> Vec<String> {
    let mut results: Vec<String> = Vec::new();

    if recursive {
        for entry in WalkDir::new(dir) {
            match entry {
                Ok(entry) => {
                    let file_path = entry.path();
                    if file_path.is_file() {
                        let result_file_path = process_file(&file_path, verbose);
                        if result_file_path != "" {
                            results.push(result_file_path);
                        }
                    }
                }
                Err(e) => {
                eprintln!("Failed to read directory: {}\n └─ Error: {}", dir, e)
                }
            }
        }
    } else {
        match fs::read_dir(dir) {
            Ok(entries) => {
                for entry in entries {
                    if let Ok(entry) = entry {
                        let file_path= entry.path();
                        if !file_path.is_file() {
                            continue;
                        }

                        let result_file_path = process_file(&file_path, verbose);
                        if result_file_path != "" {
                            results.push(result_file_path);
                        }
                    }
                }
            }
            Err(e) => {
                eprintln!("Failed to read directory: {}\n └─ Error: {}", dir, e);
                return Vec::new();
            }
        }
    }

    results
}
