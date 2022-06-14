//
//  BrowserWebView.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/14/22.
//

import SwiftUI
import WebKit

struct BrowserWebView: NSViewRepresentable {
    
    @Binding var url: URL?
    
    func makeNSView(context: Context) -> WKWebView {
        let wv = WKWebView(frame: .zero)
        return wv
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = self.url, url != nsView.url {
            nsView.load(URLRequest(url: url))
        }
    }
}
