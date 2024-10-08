//
//  NavigationBar.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var imageColor: Color
    @Binding var imageIconBackgroundColor: Color
    @Binding var titleColor: Color
    @Binding var bgColor: Color
    @Binding var titleOffset: CGFloat
    
    let title: String
    var backBtnTap: () -> ()
    
    var body: some View {
        HStack {
            Button(action: {
                self.backBtnTap()
            }) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .foregroundColor(self.imageColor)
                    .frame(width: 10, height: 17)
                    .background {
                        Circle()
                            .fill(self.imageIconBackgroundColor)
                            .frame(width: 30, height: 30)
                            .offset(x: 2)
                    }
            }
            .padding(.trailing, 10)
            
            Text(self.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(self.titleColor)
            
            Spacer()
        }
        .frame(height: 30)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .offset(x: 0, y: 30 - (self.titleOffset * 30))
        .background {
            self.bgColor
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationBar(imageColor: .constant(.black), imageIconBackgroundColor: .constant(.white), titleColor: .constant(.black), bgColor: .constant(.white), titleOffset: .constant(1),title: "극한직업") { }
}
