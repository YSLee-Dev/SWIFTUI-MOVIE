//
//  OffsetScrollView+.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/31/24.
//

import SwiftUI

struct OffsetScrollView<Content>: View where Content: View {
    @State private  var offsetY: CGFloat = 0
    private let contentsView:  (CGFloat) -> Content
    
    init(@ViewBuilder  content: @escaping (CGFloat) -> Content) {
        self.contentsView = content
    }
    
    var body: some View {
        ScrollView {
            scrollObservableView
            contentsView(self.offsetY)
        }
        .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
            self.offsetY = value
        })
    }
    
    private var scrollObservableView: some View {
        GeometryReader { geo in
            let offsetY = geo.frame(in: .global).origin.y
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: offsetY)
                .onAppear {
                    self.offsetY = offsetY
                }
        }
        .frame(height: 0)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
