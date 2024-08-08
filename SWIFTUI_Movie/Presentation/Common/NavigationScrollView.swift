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
    @Binding var titleOffset: CGFloat
    let title: String
    var isIgnoresTopSafeArea: Bool = false
    var isLargeNavigationBarShow: Bool = true
    var backBtnTap: () -> ()
    @ViewBuilder var contents: Contents
    
    var body: some View {
        OffsetScrollView {
            VStack {
                if isLargeNavigationBarShow {
                    LargeNavigationBar(title: title) {
                        self.backBtnTap()
                    }
                    .frame(height: 60)
                    .padding(EdgeInsets(top: ViewStyle.topSafeArea + 15, leading: 20, bottom: 15, trailing: 20))
                }
                self.contents
            }
        }
        .ignoresSafeArea(edges: isIgnoresTopSafeArea ? .all : .bottom)
        .overlay {
            VStack {
                NavigationBar(
                    imageColor: self.$imageColor,
                    imageIconBackgroundColor: $imageIconBackgroundColor,
                    titleColor: $titleColor,
                    bgColor: $bgColor,
                    titleOffset: $titleOffset,
                    title: self.title
                ) {
                    self.backBtnTap()
                    }
                Spacer()
            }
        }
    }
}
