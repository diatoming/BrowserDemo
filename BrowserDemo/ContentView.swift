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
    
    var body: some View {
        VStack {
            BrowserWebView(url: $url)
        }
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 680, maxHeight: .infinity)
        .presentedWindowToolbarStyle(.expanded)
        .toolbar {
            Spacer()
            TextField("", text: $urlString)
                .frame(minWidth: 500)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    refreshUrl()
                }
            
            Spacer()
        }
        .onAppear {
            refreshUrl()            
        }
    }
    
    private func refreshUrl() {
        url = URL(string: urlString)
    }
}
