//
//  DetailInfoCell.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import SwiftUI
import Kingfisher

struct DetailInfoCell: View {
    let imageName: String
    var imageURL: URL? = nil
    let title: String
    var subTitle: String? = nil
    var subView: (() -> AnyView?)? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            if imageURL != nil {
                KFImage(self.imageURL)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image(systemName: self.imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            Text(self.title)
                .font(.system(size: 15, weight: .semibold))
            
            Spacer()
            
            if let subView = self.subView, let view = subView() {
                view
            } else if let subTitle = self.subTitle {
                Text(subTitle)
                    .font(.system(size: 15, weight: .semibold))
            } 
        }
    }
}

#Preview {
    DetailInfoCell(
        imageName: "calendar.circle.fill", title: "2024년 01월 01일") {
            AnyView(
                Text("월요일")
                    .font(.system(size: 15, weight: .semibold))
            )
        }
}
