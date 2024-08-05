//
//  ActorDetailFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActorDetailFeature: Reducer {
    
    @Dependency (\.kobisManager) var kobisManager
    
    @ObservableState
    struct State: Equatable {
        let actorID: String
    }
    
    enum Action: Equatable {
        case viewInitialized
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                let actorID = state.actorID
                return .run { send in
                    
                    let data = try?  await self.kobisManager.actorDetailReqeust(actorID: actorID)
                    print(data)
                }
            }
            return .none
        }
    }
}
