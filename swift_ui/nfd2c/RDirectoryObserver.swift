//
//  RDirecotoryObserver.swift
//  nfd2c
//
//  Created by KWS on 12/4/24.
//

import Foundation

class RecursiveDirectoryObserver {
    private var streamRef: FSEventStreamRef?
    private var monitoredDirectory: URL
    private var dispatchQueue: DispatchQueue
    private var isObserving = false

    init(directoryURL: URL) {
        self.monitoredDirectory = directoryURL
        self.dispatchQueue = DispatchQueue(label: "com.recursiveDirectoryObserver.queue", qos: .background)
    }

    func startObserving(changeHandler: @escaping ([URL]) -> Void) {
        // Store the change handler so that the callback can use it
        self.changeHandler = changeHandler
        
        let pathsToWatch = [monitoredDirectory.path as CFString]
        
        var context = FSEventStreamContext(
            version: 0,
            info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), // Pass self as context
            retain: nil,
            release: nil,
            copyDescription: nil
        )

        streamRef = FSEventStreamCreate(
            kCFAllocatorDefault,
            RecursiveDirectoryObserver.callback,  // Use the static function
            &context,
            pathsToWatch as CFArray,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            2.5, // Latency in seconds
            FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes)
        )

        if let stream = streamRef {
            // FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            FSEventStreamSetDispatchQueue(stream, dispatchQueue)
            FSEventStreamStart(stream)
            isObserving = true
        }
    }

    func pauseObserving() {
        if isObserving, let stream = streamRef {
            FSEventStreamStop(stream)
            isObserving = false
        }
    }
    
    func resumeObserving() {
        if !isObserving, let stream = streamRef {
            FSEventStreamStart(stream)
            isObserving = true
        }
    }
    
    func stopObserving() {
        if let stream = streamRef {
            FSEventStreamStop(stream)
            FSEventStreamInvalidate(stream)
            FSEventStreamRelease(stream)
            streamRef = nil
            isObserving = false
        }
    }

    // Static callback function that doesn't capture context
    private static let callback: FSEventStreamCallback = { (
        streamRef: ConstFSEventStreamRef,
        clientCallBackInfo: UnsafeMutableRawPointer?,
        numEvents: Int,
        eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>,
        eventIds: UnsafePointer<FSEventStreamEventId>
    ) in
        guard let clientCallBackInfo = clientCallBackInfo else { return }
        
        let observer = Unmanaged<RecursiveDirectoryObserver>.fromOpaque(clientCallBackInfo).takeUnretainedValue()
        let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]
        
        let filteredPaths = paths.filter { !$0.hasSuffix(".DS_Store") }
        if filteredPaths.isEmpty {
            return
        }
        
        let changedURLs = paths.map { URL(fileURLWithPath: $0) }
        
        DispatchQueue.main.async {
            observer.changeHandler?(changedURLs)
        }
    }

    // Store the change handler to use it inside the static callback
    private var changeHandler: (([URL]) -> Void)?
}
