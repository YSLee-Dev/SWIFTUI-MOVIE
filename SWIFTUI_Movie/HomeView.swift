//
//  HomeView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @State var store: StoreOf<HomeFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("홈")
                .font(.title)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                .onAppear {
                    store.send(.viewInitialized)
                }
            
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
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                
                VStack(alignment: .leading) {
                    Text("전일 박스 오피스")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .center) {
                            ForEach(self.store.yesterdayMoiveList, id: \.self) {
                                HomeMovieView(rank: $0.rank, title: $0.title, urlURL: nil, date: $0.openDate)
                            }
                        }
                    }
                    .frame(height: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.gray.opacity(0.1))
                    }
                }
                .scrollTargetBehavior(ScrollViewPageing(totalCount: self.store.yesterdayMoiveList.count))
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("금주 박스 오피스")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .center) {
                            ForEach(self.store.weekMoiveList, id: \.self) {
                                HomeMovieView(rank: $0.rank, title: $0.title, urlURL: nil, date: $0.openDate)
                            }
                        }
                    }
                    .frame(height: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.gray.opacity(0.1))
                    }
                    .scrollTargetBehavior(ScrollViewPageing(totalCount: self.store.weekMoiveList.count))
                    
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
    }
}

struct ScrollViewPageing: ScrollTargetBehavior {
    let totalCount: Int
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if context.originalTarget.rect.origin.x <= 0 && target.rect.origin.y <= 0 {return}
        let wantX = context.contentSize.width / CGFloat(totalCount)
        let xValue = context.originalTarget.rect.origin.x + (target.rect.origin.x >= context.originalTarget.rect.origin.x ? wantX: -wantX) *  abs(round(context.velocity.dx))
        
        target.rect.origin = .init(x: (round(xValue/wantX) * wantX) , y: 0)
    }
}

#Preview {
    HomeView(
        store: .init(initialState: .init(), reducer: {HomeFeature()})
    )
}
