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
                    .padding(EdgeInsets(top: ViewStyle.topSafeArea + 30, leading: 20, bottom: 30, trailing: 20))
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
                    title: self.title
                ) {
                    self.backBtnTap()
                    }
                Spacer()
            }
        }
    }
}
