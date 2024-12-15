//
//  Directory.swift
//  nfd2c
//
//  Created by KWS on 12/3/24.
//

import SwiftUI

class DirectoryViewModel: ObservableObject {
    @Published var urlPath: String = ""
    @Published var changeDetected: Bool = false
    @Published var recentChanges: FileTracker<String>
    
    private let maxCount: Int
    private var directoryObserver: RecursiveDirectoryObserver?
    
    init(maxCount: Int) {
        self.maxCount = maxCount
        recentChanges = FileTracker<String>(size: maxCount)
    }
    
    func selectDirectory() {
        guard let url = selectDirectoryURL() else { return }
        
        urlPath = url.path
        updateRecentChanges(results: process_directory()) // dry-run first then observe

        directoryObserver = RecursiveDirectoryObserver(directoryURL: url)
        directoryObserver?.startObserving { [weak self] changedURLs in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.changeDetected = true
                self.updateRecentChanges(results: self.process_directory())
            }
        }
    }
    
    func selectDirectoryURL() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.title = String(localized: "Choose a Directory")
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.showsResizeIndicator = true
        
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            return openPanel.url
        }
        return nil
    }
    
    func process_directory() -> [String] {
        guard !urlPath.isEmpty else { return [] }
        
        directoryObserver?.pauseObserving()
        
        var processed: [String] = []
        urlPath.withCString { dirCString in
            let resultPointer = process_directory_c(dirCString, 1, 0)
                
            guard resultPointer != nil else {
                return
            }
            
            var index = 0

            while let currentPointer = resultPointer?[index], currentPointer != nil {
                // let cStringPointer = resultPointer![index] // Get the pointer at the current index
                let resultString = String(cString: currentPointer)
                processed.append(resultString)
                index += 1
            }
            
            free_directory_result(resultPointer)
            
        }
        
        directoryObserver?.resumeObserving()
        
        return processed
    }
    
    func updateRecentChanges(results: [String]) {
        guard !results.isEmpty else { return }
        recentChanges.append(contentsOf: results)
        
        // if recentChanges.count >= maxCount {
            // recentChanges = Array(recentChanges.suffix(maxCount))
        // }
    }
}
