mod processor;

use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int};
use std::path::Path;
use std::ptr;
use processor::{process_file, process_directory};

#[no_mangle]
pub extern "C" fn process_directory_c(dir: *const c_char, recursive: c_int, verbose: c_int) -> *mut *mut c_char {
    let c_str = unsafe { CStr::from_ptr(dir) };
    let dir_str = match c_str.to_str() {
        Ok(s) => s,
        Err(e) => {
            eprintln!("Invalid UTF-8 sequence: {}", e);
            return ptr::null_mut();
        }
    };

    let recursive = recursive != 0;
    let verbose = verbose != 0;

    let results = process_directory(dir_str, recursive, verbose);

    let mut c_strings: Vec<*mut c_char> = Vec::new();

    for result in results {
        match CString::new(result) {
            Ok(c_string) => c_strings.push(c_string.into_raw()),
            Err(_) => {
                eprintln!("Failed to convert result to CString");
                // In case of error, free previously allocated strings
                for &c_str in &c_strings {
                    unsafe {
                        if !c_str.is_null() {
                            let _ = CString::from_raw(c_str);
                        }
                    }
                }
                return ptr::null_mut();
            }
        }
    }

    // Add a null pointer at the end of the array to mark the end
    c_strings.push(ptr::null_mut());

    // Convert the Vec into a pointer to the array
    let c_array = c_strings.into_boxed_slice();
    let c_array_ptr = c_array.as_ptr() as *mut *mut c_char;

    // We need to leak the boxed slice to pass ownership to the caller
    std::mem::forget(c_array);

    c_array_ptr
}

#[no_mangle]
pub extern "C" fn process_file_c(file_path: *const c_char, verbose: c_int) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(file_path) };
    let file_str = match c_str.to_str() {
        Ok(s) => s,
        Err(e) => {
            eprintln!("Invalid UTF-8 sequence: {}", e);
            return ptr::null_mut();
        }
    };
    let path = Path::new(file_str);

    let verbose = verbose != 0;

    let result = process_file(&path, verbose);

    if result.is_empty() {
        return ptr::null_mut();
    }

    match CString::new(result) {
        Ok(c_string) => c_string.into_raw(),
        Err(_) => {
            eprintln!("Failed to convert result to CString");
            ptr::null_mut()
        }
    }
}

#[no_mangle]
pub extern "C" fn free_directory_result(result: *mut *mut c_char) {
    if result.is_null() {
        return;
    }

    unsafe {
        let mut current = result;

        while !(*current).is_null() {
            // Reconstruct the CString and let it drop to free memory
            let _ = CString::from_raw(*current);
            current = current.add(1);
        }

        // Free the outer array itself
        let _ = Box::from_raw(result);
    }
}
