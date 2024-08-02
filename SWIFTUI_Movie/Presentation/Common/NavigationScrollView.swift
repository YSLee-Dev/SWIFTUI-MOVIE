//
//  NavigationScrollView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import SwiftUI

struct NavigationScrollView<Contents>: View where Contents: View {
    @Binding var imageColor: Color
    @Binding var imageIconBackgroundColor: Color
    @Binding var titleColor: Color
    @Binding var bgColor: Color
    let title: String
    var isIgnoresTopSafeArea: Bool = false
    var backBtnTap: () -> ()
    @ViewBuilder var contents: Contents
    
    var body: some View {
        OffsetScrollView {
            self.contents
        }
        .ignoresSafeArea(edges: isIgnoresTopSafeArea ? .all : .bottom)
        .overlay {
            VStack {
                NavigationBar(
                    imageColor: self.$imageColor,
                    imageIconBackgroundColor: $imageIconBackgroundColor,
                    titleColor: $titleColor,
                    bgColor: $bgColor,
                    title: self.title
                ) {
                    self.backBtnTap()
                    }
                Spacer()
            }
        }
    }
}
