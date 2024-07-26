//
//  HomeMovieView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import SwiftUI

struct HomeMovieView: View {
    let rank: String
    let title: String
    let urlURL: URL?
    let date: String
    
    var body: some View {
        HStack(alignment: .center) {
            //            if self.urlURL == nil {
            //                RoundedRectangle(cornerRadius: 15)
            //                    .foregroundColor(.init(uiColor: .systemGray4))
            //                    .frame(width: 100, height: 150)
            //                    .overlay {
            //                        Image(systemName: "questionmark.circle")
            //                            .resizable()
            //                            .foregroundColor(.white)
            //                            .frame(width: 30, height: 30)
            //                    }
            //            } else {
            //
            //            }
            RoundedRectangle(cornerRadius: 15) // 서버 통신 개발 전까지 임시
                .foregroundColor(.init(uiColor: .systemGray4))
                .frame(width: 100, height: 150)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(self.title)
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Text("\(self.date)")
                    .font(.callout)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 40, bottom: 0, trailing: 10))
        .overlay {
            Text("\(self.rank)위")
                .font(.title)
                .bold()
                .background {
                    Circle()
                        .stroke(Color.yellow, lineWidth: 5.0)
                        .fill(.white)
                        .frame(width: 50, height: 50)
                }
                .position(CGPoint(x: 45, y: 15))
        }
    }
}

#Preview {
    HomeMovieView(
        rank: "1",
        title: "범죄도시",
        urlURL: URL(string: ""),
        date: "2024년 01월 01일"
    )
}
