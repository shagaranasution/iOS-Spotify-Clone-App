//
//  SCAuthViewController.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit
import WebKit

final class SCAuthViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webPagePreferences = WKWebpagePreferences()
        webPagePreferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = webPagePreferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    public var completionHandler: ((_ success: Bool) -> Void)?
    
    // - MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self
        guard let url = SCAuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
}

// - MARK: Extension WKNavigation Delegate

extension SCAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url,
              let code =
                URLComponents(string: url.absoluteString)?
            .queryItems?
            .first(where: { $0.name == "code"})?
            .value else {
            return
        }
        webView.isHidden = true
        
        SCAuthManager.shared.requestExchangeToToken(
            forCode: code
        ) { success in
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: false)
                self?.completionHandler?(success)
            }
        }
    }
    
}
