//
//  TopSitesManager.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/15/22.
//

import Foundation

class TopSitesManager {
    static let shared = TopSitesManager()
    
    private(set) var sitesInfo: [String: Int] = [:]
    
    func update(site: String) {
        if let score = sitesInfo[site] {
            sitesInfo[site] = score + 1
        } else {
            sitesInfo[site] = 1
        }
    }
    
    func load() {
        guard let data = UserDefaults.standard.value(forKey: .topSitesInfo) as? Data else { return }
        sitesInfo = try! JSONDecoder().decode([String: Int].self, from: data)
        
        dump(sitesInfo)
    }
    
    func save() {
        let data = try! JSONEncoder().encode(sitesInfo)
        UserDefaults.standard.setValue(data, forKey: .topSitesInfo)
    }
}

extension String {
    static let topSitesInfo = "topSitesInfo"
}
