//
//  DetailInfoView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/1/24.
//

import SwiftUI

struct DetailInfoView<Contents>: View where Contents: View{
    let title: String
    @ViewBuilder var contents: Contents
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.title)
                .font(.title2)
                .bold()
            
            LazyVStack(alignment: .leading, spacing: 20)  {
                self.contents
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
            }
        }
        .padding(20)
    }
}

#Preview {
    DetailInfoView(title: "DetailInfoView") {
        Text("123")
    }
}
