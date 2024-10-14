//
//  CustomBottomSheetView.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import SwiftUI

struct CustomBottomSheet<Content: View>: View {
    @State private var offset: CGFloat
    @State private var lastDragValue: CGFloat = 0
    
    private let content: Content
    private let maxHeight: CGFloat = ContentSize.bottomSheetMax.size.height
    private let mediumHeight: CGFloat = ContentSize.bottomSheetMax.size.height / 2
    private let minHeight: CGFloat = 50

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = State(initialValue: maxHeight - minHeight)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .padding(.top, 8)
                    content
                        .frame(height: maxHeight - self.offset)
                        .clipped()
                }
                .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .offset(y: max(self.offset, 0))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let dragOffset = value.translation.height
                            self.offset = dragOffset + self.lastDragValue
                         
                            if self.offset > maxHeight - minHeight {
                                self.offset = maxHeight - minHeight
                            }
                        }
                        .onEnded { value in
                            let endPosition = value.translation.height + self.lastDragValue
                            if endPosition > maxHeight / 2 {
                                if endPosition > (maxHeight + mediumHeight) / 2 {
                                    self.offset = maxHeight - minHeight
                                } else {
                                    self.offset = maxHeight - mediumHeight
                                }
                            } else {
                                self.offset = 0
                            }
                            self.lastDragValue = self.offset
                        }
                )
                .animation(.interactiveSpring(), value: offset)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
