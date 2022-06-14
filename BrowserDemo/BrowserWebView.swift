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
        
        let config = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.navigationDelegate = context.coordinator
        
        // disable webview background color
        wv.setValue(false, forKey: "drawsBackground")
        
        return wv
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = self.url, url != nsView.url {
            nsView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> BrowserWebViewCoordinator {
        BrowserWebViewCoordinator(self)
    }
}

extension BrowserWebView {
    class BrowserWebViewCoordinator: NSObject, WKNavigationDelegate {
        
        var parent: BrowserWebView
        
        var changed = false
        
        init(_ webView: BrowserWebView) {
            self.parent = webView
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                
                dump(url)
                
                decisionHandler(.allow)
                return
            }
            
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            if let url = webView.url, url.absoluteString.contains("addons.mozilla.org") {
                let js = """
                const remove = (sel) => document.querySelectorAll(sel).forEach(el => el.remove());
                remove(".GetFirefoxButton");

                var link = document.getElementsByClassName('InstallButtonWrapper-download-link')[0];
                link.classList.remove('InstallButtonWrapper-download-link');
                link.classList.add('Button', 'Button--action', 'GetFirefoxButton-button', 'Button--puffy');
                link.innerHTML = "Add to Orion";
                link.style.color = 'white';
                """
                
                webView.evaluateJavaScript(js) { result, err in
                }
            }
        }
    }
}
