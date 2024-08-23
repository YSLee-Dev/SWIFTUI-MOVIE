//
//  LargeNavigationBar.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/5/24.
//

import SwiftUI

struct LargeNavigationBar: View {
    let title: String
    var backBtnImageName: String = "chevron.backward"
    var backBtnSize: CGSize = .init(width: 12, height: 22)
    var backBtnTap: () -> ()
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: self.backBtnImageName)
                .resizable()
                .foregroundColor(.black)
                .frame(width: self.backBtnSize.width, height: self.backBtnSize.height)
                .padding(.trailing, 10)
                .onTapGesture {
                    self.backBtnTap()
                }
            
            Text(self.title)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
        }
    }
}
