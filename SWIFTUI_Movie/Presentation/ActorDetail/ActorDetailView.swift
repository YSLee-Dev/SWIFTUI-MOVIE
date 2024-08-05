//
//  ActorDetailView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/4/24.
//

import SwiftUI
import ComposableArchitecture

struct ActorDetailView: View {
    @State var store: StoreOf<ActorDetailFeature>
    
    init(store: StoreOf<ActorDetailFeature>) {
        self.store = store
        self.store.send(.viewInitialized)
    }
    
    var body: some View {
        Text("\(self.store.state.actorID)")
    }
}

#Preview {
    ActorDetailView(
        store: .init(initialState: .init(actorID: "123"), reducer: {ActorDetailFeature()})
    )
}
