//
//  BridgingHeader.h
//  nfd2c
//
//  Created by KWS on 12/3/24.
//

#ifndef BridgingHeader_h
#define BridgingHeader_h

char** process_directory_c(const char *dir, int recursive, int verbose);
// char* process_file_c(const char *file_path, int verbose);
char* normalize_name_c(const char *file_path, int verbose, int is_file);
void free_directory_result(char **result);

#endif /* BridgingHeader_h */
