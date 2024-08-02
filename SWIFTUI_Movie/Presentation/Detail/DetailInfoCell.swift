//
//  DetailInfoCell.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import SwiftUI

struct DetailInfoCell: View {
    let imageName: String
    let title: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: self.imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            
            Text(self.title)
                .font(.system(size: 15, weight: .semibold))
            
            Spacer()
        }
    }
}

#Preview {
    DetailInfoCell(imageName: "calendar.circle.fill", title: "2024년 01월 01일")
}
