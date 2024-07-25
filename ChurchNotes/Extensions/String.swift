//
//  String.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 5/22/24.
//

import SwiftUI

extension String {
    func toMarkdown() -> AttributedString {
        do {
            return try AttributedString(markdown: self)
        } catch {
            print("Error parsing Markdown for string \(self): \(error)")
            return AttributedString(self)
        }
    }
}
