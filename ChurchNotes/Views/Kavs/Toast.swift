//
//  Toast.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 1/7/24.
//

import SwiftUI

struct RootView<Content: View>: View {
    @ViewBuilder var content: Content
    /// View Properties
    @State private var overlayWindow: UIWindow?
    var body: some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    /// View Controller
                    let rootController = UIHostingController(rootView: ToastGroup())
                    rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    
                    overlayWindow = window
                }
            }
    }
}

fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        return rootViewController?.view == view ? nil : view
    }
}

@Observable
class Toast {
    static let shared = Toast()
    fileprivate var toasts: [ToastItem] = []
    
    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .medium) {
        
        withAnimation(.snappy) {
            toasts.append(
                .init(
                    title: title,
                    symbol: symbol,
                    tint: tint,
                    isUserInteractionEnabled: isUserInteractionEnabled,
                    timing: timing
                )
            )
        }
    }
}

fileprivate struct ToastItem: Identifiable {
    let id: UUID = .init()
    /// Custom Properties
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    /// Timing
    var timing: ToastTime = .medium
}

enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 3.0
    case long = 5.0
}

fileprivate struct ToastGroup: View {
    var model = Toast.shared
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                        .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
                }
            }
            .padding(.bottom, safeArea.top == .zero ? 15 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    func offsetY(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    func scale(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}

fileprivate struct ToastView: View {
    var size: CGSize
    var item: ToastItem
    /// View Properties
    @State private var delayTask: DispatchWorkItem?
    @State var bouncing = false
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .symbolEffect(.bounce, value: bouncing)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            Text(item.title)
                .font(.system(size: 16))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        //        .background(
        //            Color(K.Colors.mainColor),
        //            .background
        //                .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
        //                .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
        //            in: .rect(cornerRadius: 7)
        //            RoundedRectangle(cornerRadius: 7)
        //                .fill(Color.black)
        //                .opacity(0.75)
        //                .blur(radius: 5)
        //        )
        .background(
            ZStack{
                GlassBackGround(width: UIScreen.screenWidth - 30, height: 40, color: Color(K.Colors.lightGray))
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                TransparentBlurView(removeAllFilters: false)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
                    .cornerRadius(7)
            }
        )
        .contentShape(.rect(cornerRadius: 7))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    
                    if (endY + velocityY) > 100 {
                        /// Removing Toast
                        removeToast()
                    }
                })
        )
        .onAppear {
            bouncing = true
            guard delayTask == nil else { return }
            delayTask = .init(block: {
                removeToast()
            })
            
            if let delayTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
            }
        }
        /// Limiting Size
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
        //        .padding(.bottom, 50)
        .transition(.offset(y: 150))
    }
    
    func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        
        withAnimation(.snappy) {
            Toast.shared.toasts.removeAll(where: { $0.id == item.id })
        }
    }
}

#Preview {
    RootView {
        ContentView()
    }
}


struct GlassBackGround: View {
    
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                           startRadius: 1,
                           endRadius: 100)
            .opacity(0.6)
            Rectangle().foregroundColor(color)
        }
        .opacity(0.3)
        .blur(radius: 5)
        .cornerRadius(7)
        .frame(width: width, height: height)
    }
}
