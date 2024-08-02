//
//  NavigationBar.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var imageIconBackgroundColor: Color
    @Binding var titleColor: Color
    @Binding var bgColor: Color
    let title: String
    var backBtnTap: () -> ()
    
    var body: some View {
        HStack {
            Button(action: {
                self.backBtnTap()
            }) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 10, height: 17)
                    .background {
                        Circle()
                            .fill(self.imageIconBackgroundColor)
                            .frame(width: 30, height: 30)
                            .offset(x: 2)
                    }
            }
            
            Spacer()
            
            Text(self.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(self.titleColor)
                .padding(.trailing, 10)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background {
            self.bgColor
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationBar(imageIconBackgroundColor: .constant(.white), titleColor: .constant(.black), bgColor: .constant(.white),title: "극한직업") { }
}
