//
//  AppView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @State var store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStack(path: self.$store.scope(state: \.path, action: \.path), root: {
            TabView(selection: self.$store.nowTappedIndex) {
                HomeView(store: self.store.scope(state: \.homeState, action: \.homeAction))
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                
                TotalMemoView(store: self.store.scope(state: \.totalMemoState, action: \.totalMemoAction))
                    .tabItem {
                        Image(systemName: "folder")
                    }
                    .tag(1)
            }
            .onAppear {
                UITabBar.appearance().barTintColor = .white
            }
        }) { store in
            switch store.state {
            case .detailState:
                if let store = store.scope(state: \.detailState, action: \.detailAction) {
                    DetailView(store: store)
                        .navigationBarBackButtonHidden()
                }
            case .detailActorsState(_):
                if let store = store.scope(state: \.detailActorsState, action: \.detailActorsAction) {
                    DetailActorsView(store: store)
                        .navigationBarBackButtonHidden()
                }
            case .actorDetailState(_):
                if let store = store.scope(state: \.actorDetailState, action: \.actorDetailAction) {
                    ActorDetailView(store: store)
                        .navigationBarBackButtonHidden()
                }
            case .searchState(_):
                if let store = store.scope(state: \.searchState, action: \.searchAction) {
                    SearchView(store: store)
                        .navigationBarBackButtonHidden()
                }
            }
        }
   
    }
}

#Preview {
    AppView(store: .init(initialState: .init(homeState: .init(), totalMemoState: .init()), reducer: {AppFeature()}))
}
