//
//  HomeView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import SwiftUI

// 임시 데이터 struct
struct Temp: Hashable {
    let title: String
    let rank: Int
    let date: String
    let image: URL?
}

struct HomeView: View {
    var body: some View {
        
        let tempData: [Temp] = [
            .init(title: "범죄도시", rank: 1, date: "2024년 01월 01일", image: nil),
            .init(title: "극한직업", rank: 2, date: "2024년 02월 11일", image: nil),
            .init(title: "짱구는 못말려 극장판", rank: 3, date: "2024년 03월 21일", image: nil),
            .init(title: "알라딘", rank: 4, date: "2024년 04월 02일", image: nil),
            .init(title: "7번방의 꿈", rank: 5, date: "2024년 05월 12일", image: nil),
            .init(title: "스파이더맨", rank: 6, date: "2024년 06월 13일", image: nil)
        ]
        
        VStack(alignment: .leading) {
            Text("홈")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            ScrollView {
                Button(action: {
                    
                }) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                        .overlay {
                            HStack(alignment: .center) {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                
                                Text("관심있는 영화 검색하기")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                        }
                }
                .frame(height: 50)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("금일 박스 오피스")
                        .font(.title2)
                        .bold()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .center) {
                            ForEach(tempData, id: \.self) {
                                HomeMovieView(rank: $0.rank, title: $0.title, urlURL: $0.image, date: $0.date)
                            }
                        }
                    }
                    .frame(height: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.1))
                    }
                }
                .scrollTargetBehavior(ScrollViewPageing(totalCount: tempData.count))
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("금주 박스 오피스")
                        .font(.title2)
                        .bold()
                    
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .center) {
                            ForEach(tempData, id: \.self) {
                                HomeMovieView(rank: $0.rank, title: $0.title, urlURL: $0.image, date: $0.date)
                            }
                        }
                        .frame(height: 200)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.1))
                        }
                    }
                    .scrollTargetBehavior(ScrollViewPageing(totalCount: tempData.count))
                    
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
    }
}

struct ScrollViewPageing: ScrollTargetBehavior {
    let totalCount: Int
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let wantX = context.contentSize.width / CGFloat(totalCount)
        let xValue = context.originalTarget.rect.origin.x + (target.rect.origin.x >= context.originalTarget.rect.origin.x ? wantX: -wantX) *  abs(round(context.velocity.dx))
        
        target.rect.origin = .init(x: (round(xValue/wantX) * wantX) , y: 0)
    }
}

#Preview {
    HomeView()
}
