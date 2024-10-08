//
//  HomeMovieView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import SwiftUI
import Kingfisher

struct HomeMovieView: View {
    let rank: String
    let title: String
    let url: URL?
    let date: String
    
    var body: some View {
        VStack(alignment: .center) {
         KFImage(url)
                .placeholder {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.init(uiColor: .systemGray4))
                        .frame(width: 100, height: 150)
                        .padding(.bottom, 5)
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))
       
            Text(self.title)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: 100)
            
            Text("\(self.date)")
                .font(.callout)
        }
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 0, trailing: 30))
        .overlay {
            Text("\(self.rank)")
                .font(.system(size: 50, weight: .black, design: .serif))
                .position(CGPoint(x: 30, y: 15))
        }
    }
}

#Preview {
    HomeMovieView(
        rank: "1",
        title: "범죄도시",
        url: URL(string: ""),
        date: "2024년 01월 01일"
    )
}
