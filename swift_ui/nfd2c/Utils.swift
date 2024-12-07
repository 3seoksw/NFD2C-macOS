//
//  Utils.swift
//  nfd2c
//
//  Created by KWS on 12/5/24.
//

import AppKit

func shortenUserPath(_ path: String) -> String {
    let homeDirectory = "/Users/\(NSUserName())"
    if path.starts(with: homeDirectory) {
        return path.replacingOccurrences(of: homeDirectory, with: "~")
    }
    return path
}

func shortenPath(_ startPath: String, _ path: String) -> String {
    guard path.starts(with: startPath) else { return path }
    let replacingPath = startPath + "/"
    return path.replacingOccurrences(of: replacingPath, with: "")
}

func getPathIcon(for path: String) -> NSImage {
    // return NSWorkspace.shared.icon(for: path)
    return NSWorkspace.shared.icon(forFile: path)
}

struct FileTracker<T>: RandomAccessCollection {
    private var queue: [T?] = []
    private var maxSize: Int
    
    init(size: Int) {
        self.maxSize = size
    }
    
    public var count: Int {
        return queue.count
    }
    
    public var isEmpty: Bool {
        return queue.isEmpty
    }
    
    public mutating func dequeue() -> T? {
        guard !queue.isEmpty else { return nil }
        return queue.removeFirst()
    }
    
    public mutating func enqueue(_ element: T) {
        queue.append(element)
        if queue.count > maxSize {
            queue.removeFirst()
        }
    }
    
    public mutating func append(contentsOf elements: [T]) {
        queue.append(contentsOf: elements)
        if queue.count > maxSize {
            queue.removeFirst(queue.count - maxSize)
        }
    }
    
    typealias Index = Int
    typealias Element = T
    
    public var startIndex: Int {
        return queue.startIndex
    }
    
    public var endIndex: Int {
        return queue.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return queue.index(after: i)
    }
    
    public func index(before i: Int) -> Int {
        return queue.index(before: i)
    }
    
    public subscript(position: Int) -> T {
        return queue[position]!
    }
}
