//
//  ContentView.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var urlString = "https://addons.mozilla.org/en-US/firefox/addon/top-sites-button/"
    @State private var url: URL?
    
    @State private var plugin: FirefoxPlugin?
    
    var body: some View {
        VStack {
            BrowserWebView(url: $url)
        }
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 680, maxHeight: .infinity)
        .presentedWindowToolbarStyle(.expanded)
        .toolbar {
            ToolbarItemGroup {
                Spacer()
                TextField("", text: $urlString)
                    .frame(minWidth: 500)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        refreshUrl()
                    }
                
                Spacer()
                
                
                if let plugin = plugin {
                    Button {
                        
                    } label: {
                        plugin.iconImage
                            .resizable().aspectRatio(contentMode: .fit)
                            .help(plugin.manifest?.name ?? "Some Plugin")
                    }
                }
            }
        }
        .onAppear {
            refreshUrl()
        }
        .onReceive(NotificationCenter.default.publisher(for: .firefoxPluginInstalled)) { noti in
            guard let plugin = noti.object as? FirefoxPlugin else {
                return
            }
            self.plugin = plugin
        }
    }
    
    private func refreshUrl() {
        url = URL(string: urlString)
    }
}

extension FirefoxPlugin: Identifiable {
    var id: URL { url }
    
    var iconImage: Image {
        guard let img = icon else { return Image(systemName: "puzzlepiece.extension.fill")}
        return Image(nsImage: img)
    }
}
