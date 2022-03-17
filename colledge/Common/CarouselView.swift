//
//  CarouselView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct CarouselView<Content: View>: View {
    private var numberOfItems: Int
    private var content: Content
    @State var slideGesture: CGSize = CGSize.zero
    @State private var currentIndex: Int = 0

    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfItems = numberOfImages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    self.content
                }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                    .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
                    .animation(.spring(), value: self.currentIndex)
                    .gesture(DragGesture()
                        .onChanged{ value in
                            self.slideGesture = value.translation
                        }
                        .onEnded{ value in
                            if self.slideGesture.width < -50 {
                                if self.currentIndex < self.numberOfItems - 1 {
                                    withAnimation {
                                        self.currentIndex += 1
                                    }
                                }
                            }
                            if self.slideGesture.width > 50 {
                                if self.currentIndex > 0 {
                                    withAnimation {
                                        self.currentIndex -= 1
                                    }
                                }
                            }
                            self.slideGesture = .zero
                        })
                HStack(spacing: 3) {
                    ForEach(0..<self.numberOfItems, id: \.self) { index in
                        Button(action: {
                            self.currentIndex = index
                        }, label: {
                            Circle()
                                .frame(width: index == self.currentIndex ? 14 : 10,
                                       height: index == self.currentIndex ? 14 : 10)
                                .foregroundColor(index == self.currentIndex ? Color.blue : .gray)
                                .padding(.top)
                                .animation(.spring(), value: self.currentIndex)
                        })
                    }
                }
            }
        }
    }
}
