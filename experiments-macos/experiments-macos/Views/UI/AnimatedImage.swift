//
//  AnimatedImage.swift
//  Subjective Self Tracking
//
//  Alexander Johansson 2024
//

import SwiftUI
import AppKit
import WebKit

public struct AnimatedImage: NSViewRepresentable {
    private let name: String
    init(_ name: String) {
        self.name = name
    }

    public func makeNSView(context: Context) -> WKWebView {
        let webview = NoScrollWKWebView()
        webview.allowsLinkPreview = true
        webview.setValue(false, forKey: "drawsBackground")
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else {
            fatalError("Failed to load gif resource: \(name).gif")
        }
                
        do {
            let data = try Data(contentsOf: url)
            webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        } catch {
            fatalError("Failed to load data from url: \(url)")
        }
        return webview
    }
    
    public func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.reload()
    }
}

public class NoScrollWKWebView: WKWebView {
    public override func scrollWheel(with theEvent: NSEvent) {
        nextResponder?.scrollWheel(with: theEvent)
    }
}

#Preview {
    AnimatedImage("front_black_white")
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
}
