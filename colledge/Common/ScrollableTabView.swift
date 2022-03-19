//
//  ScrollableTabView.swift
//  colledge
//
//  Created by Ромка Бережной on 19.03.2022.
//

import SwiftUI

struct ScrollableTabBar<Content: View>: UIViewRepresentable {
    
    var content: Content
    
    var rect: CGRect
    
    @Binding var offset: CGFloat
    
    var count: Int
    
    let scrollView = UIScrollView()
    
    init(count: Int, rect: CGRect, offset: Binding<CGFloat>, @ViewBuilder content: ()-> Content) {
        self.content = content()
        self._offset = offset
        self.rect = rect
        self.count = count
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        setUpScrollView()
        
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(count), height: rect.height)
        
        scrollView.addSubview(extractView())
        
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if uiView.contentOffset.x != offset {
            
            uiView.delegate = nil
            
            UIView.animate(withDuration: 0.4) {
                uiView.contentOffset.x = offset
            } completion: { (status) in
                if status { uiView.delegate = context.coordinator }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return ScrollableTabBar.Coordinator(parent: self)
    }
    
    func setUpScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func extractView() -> UIView {
        let controller = UIHostingController(rootView: HStack(spacing: 0){content}.ignoresSafeArea())
        controller.view.frame = CGRect(x: 0, y: 0, width: rect.width * CGFloat(count), height: rect.height)
        return controller.view!
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollableTabBar
        
        init(parent: ScrollableTabBar) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
    }
}
