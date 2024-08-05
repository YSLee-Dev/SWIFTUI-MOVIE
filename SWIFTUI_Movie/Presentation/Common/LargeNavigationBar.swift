//
//  LargeNavigationBar.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/5/24.
//

import SwiftUI

struct LargeNavigationBar: View {
    let title: String
    var backBtnTap: () -> ()
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "chevron.backward")
                .resizable()
                .foregroundColor(.black)
                .frame(width: 12, height: 22)
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
