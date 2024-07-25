//
//  GifImageView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 7/20/24.
//

import SwiftUI
import WebKit

struct GifImageView: UIViewRepresentable {
    private let name: String
//    private let url: URL

    init(_ name: String/*, url: URL*/) {
        self.name = name
//        self.url = url
    }
func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
    let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        return webview
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
