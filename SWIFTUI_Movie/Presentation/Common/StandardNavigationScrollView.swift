//
//  StandardNavigationScrollView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import SwiftUI

struct StandardNavigationScrollView<Contents>: View where Contents: View {
    @State private var titleChageRatio: CGFloat = 0
    
    let title: String
    var backBtnTap: () -> ()
    @ViewBuilder var contents: Contents
    
    var body: some View {
        NavigationScrollView(
            imageColor: .constant(.black.opacity(self.titleChageRatio)),
            imageIconBackgroundColor: .constant(.clear),
            titleColor: .constant(.black.opacity(self.titleChageRatio)),
            bgColor: .constant(.white.opacity(self.titleChageRatio)),
            titleOffset: .constant(self.titleChageRatio),
            title: self.title,
            isIgnoresTopSafeArea: true,
            backBtnTap: {
                self.backBtnTap()
            }) {
                self.contents
        }
        .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
            if  -(value) > 20 && self.titleChageRatio < 1 {
                self.titleChageRatio = (-value - 20) / 40
            } else if -(value) <= 60 && self.titleChageRatio >= 1 {
                self.titleChageRatio = max(0,  (-value - 20) / 40)
            } else {
                if -(value) > 20 {
                    self.titleChageRatio = 1
                } else {
                    self.titleChageRatio = 0
                }
            }
        })
    }
}
