//
//  SWIFTUI_MovieApp.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct SWIFTUI_MovieApp: App {
    let store: StoreOf<AppFeature> = .init(initialState: .init(homeState: .init(), totalMemoState: .init()), reducer: {AppFeature()})
    
    var body: some Scene {
        WindowGroup {
            AppView(store: self.store)
        }
    }
}
