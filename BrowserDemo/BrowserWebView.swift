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
    class BrowserWebViewCoordinator: NSObject, WKNavigationDelegate, WKDownloadDelegate {
                
        var parent: BrowserWebView
        private var downloadDestinationURL: URL?
        
        init(_ webView: BrowserWebView) {
            self.parent = webView
        }
        
        // MARK: - Download
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if navigationAction.shouldPerformDownload {
                   decisionHandler(.download, preferences)
               } else {
                   decisionHandler(.allow, preferences)
               }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if navigationResponse.canShowMIMEType {
                decisionHandler(.allow)
            } else {
                decisionHandler(.download)
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            dump(navigationAction.request.url)
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            download.delegate = self
        }
        
        func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
            download.delegate = self
        }
        
        func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String) async -> URL? {
            let temporaryDir = NSTemporaryDirectory()
            let fileName = temporaryDir + "/" + suggestedFilename
            let url = URL(fileURLWithPath: fileName)
            downloadDestinationURL = url
            return downloadDestinationURL
        }
        
        func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
            assertionFailure(error.localizedDescription)
        }
        
        func downloadDidFinish(_ download: WKDownload) {
            if let url = downloadDestinationURL {
                dump(url)
            }
            downloadDestinationURL = nil
        }
        
        // MARK: - Navigation
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            if let url = webView.url, url.absoluteString.isFirefoxAddonsSite {
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
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            assertionFailure(error.localizedDescription)
        }
        
    }
}

extension String {
    var isFirefoxAddonsSite: Bool {
        contains("addons.mozilla.org")
    }
}
