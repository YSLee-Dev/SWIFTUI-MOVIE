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
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
        self.store.send(.viewInitialized)
    }
    
    var body: some View {
        NavigationStack(path: self.$store.scope(state: \.path, action: \.path), root: {
            VStack(alignment: .leading) {
                Text("홈")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                
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
                                ForEach(Array(zip(self.store.yesterdayMoiveList.indices, self.store.yesterdayMoiveList)), id: \.0) { index, data in
                                    HomeMovieView(rank: data.rank, title: data.title, url: data.url, date: data.openDate)
                                        .onTapGesture {
                                            self.store.send(.movieTapped(.yesterday, index))
                                        }
                                }
                            }
                        }
                        .frame(height: 250)
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
                                ForEach(Array(zip(self.store.weekMoiveList.indices, self.store.weekMoiveList)), id: \.0) { index, data in
                                    HomeMovieView(rank: data.rank, title: data.title, url: data.url, date: data.openDate)
                                        .onTapGesture {
                                            self.store.send(.movieTapped(.week, index))
                                        }
                                }
                            }
                        }
                        .frame(height: 250)
                        .background {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color.gray.opacity(0.1))
                        }
                        .scrollTargetBehavior(ScrollViewPageing(totalCount: self.store.weekMoiveList.count))
                        
                        Spacer()
                    }
                }
            }
            .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
        }) { store in
            switch store.state {
            case .detailState:
                if let reduce = store.scope(state: \.detailState, action: \.detailAction) {
                    DetailView(store: reduce)
                        .navigationBarBackButtonHidden()
                }
            case .detailActorsState(_):
                if let reduce = store.scope(state: \.detailActorsState, action: \.detailActorsAction) {
                    DetailActorsView(store: reduce)
                        .navigationBarBackButtonHidden()
                }
            case .actorDetailState(_):
                if let reduce = store.scope(state: \.actorDetailState, action: \.actorDetailAction) {
                    ActorDetailView(store: reduce)
                        .navigationBarBackButtonHidden()
                }
            }
        }
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
