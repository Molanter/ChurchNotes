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

struct LeftSidePath: Shape {
    func path(in rect: CGRect) -> Path {
        return getPath(in: rect)
    }
    
    private func getPath(in rect: CGRect) -> Path {
        let height = rect.height
        let width = rect.width
        
        return Path { p in
            let h = (height / 3) * 2
            let w = width / 5

            p.move(to: CGPoint(x: 0, y: 0))
            p.addLine(to: CGPoint(x: 0, y: h))

            p.addCurve(
                to: CGPoint(x: 0, y: 0),
                control1: CGPoint(x: w, y: (h / 3) * 2),
                control2: CGPoint(x: w, y: (h / 3))
            )

            p.closeSubpath()
        }
    }
}

struct RightSidePath: Shape {
    func path(in rect: CGRect) -> Path {
        return getPath(in: rect)
    }
    
    private func getPath(in rect: CGRect) -> Path {
        let height = rect.height
        let width = rect.width
        
        return Path { p in
            let h = (height / 3) * 2
            let w = (width / 5) * 4
            let min = height - h
            p.move(to: CGPoint(x: width, y: height - h))
            p.addLine(to: CGPoint(x: width, y: height))

            p.addCurve(
                to: CGPoint(x: width, y: height - h),
                control1: CGPoint(x: w, y: ((h / 3) * 2) + min),
                control2: CGPoint(x: w, y: (h / 3) + min)
            )

            p.closeSubpath()
        }
    }
}
