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
    }
}

#Preview {
    AppView(store: .init(initialState: .init(homeState: .init(), totalMemoState: .init()), reducer: {AppFeature()}))
}
