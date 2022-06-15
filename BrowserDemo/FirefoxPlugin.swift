//
//  FirefoxPlugin.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/15/22.
//

import Foundation
import ZIPFoundation
import AppKit

struct FirefoxPlugin {
    let url: URL
    
    var icon: NSImage?
    
    static func install(from url: URL) async throws {

        let plugin = FirefoxPlugin(url: url)
        
        if let plugFolder = plugin.unzip(at: url) {
            dump(plugFolder)
        }
    }
    
    func unzip(at url: URL) -> URL? {
        let fileManager = FileManager()
        let currentWorkingPath = url.deletingLastPathComponent().path
        let sourceURL = URL(fileURLWithPath: url.path)
        let name = sourceURL.lastPathComponent
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent("\(name) unzip")
        do {
            try fileManager.removeItem(at: destinationURL)
            try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            try fileManager.unzipItem(at: sourceURL, to: destinationURL)
            return destinationURL
        } catch {
            print("Extraction of ZIP archive failed with error:\(error)")
            return nil
        }
    }
}
