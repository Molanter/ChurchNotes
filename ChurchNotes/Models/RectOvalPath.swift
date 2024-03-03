//
//  RectOvalPath.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 2/10/24.
//

import SwiftUI

struct RectOvalPath: Shape{
    func path(in rect: CGRect) -> Path {
        return getPath(in: rect)
    }
    
    private func getPath(in rect: CGRect) -> Path {
        let width = rect.width
        
        return Path { p in
//            p.move(to: .zero)
//            p.move(to: CGPoint(x: 0, y: 0))
//            p.move(to: CGPoint(x: width, y: 0))
//            p.move(to: CGPoint(x: width, y: 100))

            p.addLines([
                CGPoint(x: 0, y: 0),
                CGPoint(x: width, y: 0),
                CGPoint(x: width, y: 160)//,
                //                CGPoint(x: 0, y: 100)
            ])
            p.addCurve(
                    to: CGPoint(x: 0, y: 160),
                    control1: CGPoint(x: (width / 3) * 2, y: 210),
                    control2: CGPoint(x: width / 3, y: 210)
            )
//            p.move(to: .zero)

            p.addLines([
                CGPoint(x: 0, y: 0)
            ])
            p.closeSubpath()
        }
    }
}
