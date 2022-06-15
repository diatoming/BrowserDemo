//
//  FirefoxPlugin.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/15/22.
//

import Foundation
import ZIPFoundation
import AppKit

struct Manifest: Codable {
    var mainfestVersion: Int?
    var version: String?
    var name: String?
    var description: String?
    var icons: [String: String] = [:]
}

struct FirefoxPlugin {
    /// xpi url
    let url: URL
    
    var unzipFoldereURL: URL?
    private(set) var icon: NSImage?
    private(set) var manifest: Manifest?
    
    private var biggestIcon: NSImage? {
        guard let url = unzipFoldereURL, let manifest = manifest else { return nil }
        let key = manifest.icons.keys.compactMap(Int.init).sorted(by: >).first
        guard let intKey = key,
              let img = manifest.icons[String(intKey)] else { return nil }
        let imgUrl = url.appendingPathComponent(img)
        return NSImage(contentsOf: imgUrl)
    }
    
    static func install(from url: URL) async throws {
        
        var plugin = FirefoxPlugin(url: url)
        
        if let plugFolder = plugin.unzip(at: url) {
            plugin.parse(folder: plugFolder)
        }
    }
    
    private mutating func parse(folder: URL) {
        unzipFoldereURL = folder
        let manifestUrl = folder.appendingPathComponent("manifest.json")
        guard let manifestData = try? Data(contentsOf: manifestUrl) else { return }
        let manifest = try! JSONDecoder().decode(Manifest.self, from: manifestData)
        self.manifest = manifest
        self.icon = icon ?? biggestIcon
        
        let copy = self
        DispatchQueue.main.async {        
            NotificationCenter.default.post(name: .firefoxPluginInstalled, object: copy)
        }
    }
    
    private func unzip(at url: URL) -> URL? {
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

extension Notification.Name {
    static let firefoxPluginInstalled = Self("firefoxPluginInstalled")
}
