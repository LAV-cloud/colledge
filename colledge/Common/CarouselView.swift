import SwiftUI

struct CarouselView<Content: View>: View {
    private var numberOfItems: Int
    private var offset: Double
    private var content: Content
    
    @State var slideGesture: CGSize = CGSize.zero
    
    @Binding var currentIndex: Int
    @Binding var days: [Day]
    @Binding var selectedDay: Day?
    
    init(
        numberOfImages: Int,
        offset: Double,
        days: Binding<[Day]>,
        selectedDay: Binding<Day?>,
        currentIndex: Binding<Int>,
        @ViewBuilder content: () -> Content
    ) {
        self.numberOfItems = numberOfImages
        self.offset = offset
        self._days = days
        self._selectedDay = selectedDay
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                self.slideGesture = value.translation
            }
            .onEnded{ value in
                if selectedDay != nil {
                    if self.slideGesture.width < -50 {
                        if currentIndex < self.numberOfItems - 1 {
                            withAnimation {
                                currentIndex += 1
                            }
                        }
                    }
                    if self.slideGesture.width > 50 {
                        if currentIndex > 0 {
                            withAnimation {
                                currentIndex -= 1
                            }
                        }
                    }
                    self.selectedDay = days[currentIndex]
                }
                self.slideGesture = .zero
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: self.offset) {
                    self.content
                        .animation(.spring(), value: slideGesture)
                        .offset(x: slideGesture.width, y: 0)
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .leading
                )
                .offset(x: CGFloat(self.currentIndex) * (-geometry.size.width - self.offset), y: 0)
                .animation(.spring(), value: self.currentIndex)
                .gesture(gesture)
            }
        }
    }
}
