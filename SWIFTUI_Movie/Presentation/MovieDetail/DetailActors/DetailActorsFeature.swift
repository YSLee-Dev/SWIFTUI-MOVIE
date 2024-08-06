//
//  DetailActorsFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailActorsFeature: Reducer {
    
    @Dependency (\.dismiss) var dismiss
    
    @ObservableState
    struct State:  Equatable {
        let moiveTitle: String
        let actorList: [KobisMovieInfoActors]
        var actorInfoLoading: Int?
    }
    
    enum Action: Equatable {
        case backBtnTapped
        case actorTapped(Int)
        case actorDetailInfoRequestEND
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .actorTapped(let index):
                state.actorInfoLoading = index
                return .none
                
            case .actorDetailInfoRequestEND:
                state.actorInfoLoading = nil
                return .none
                
            default: return .none
            }
        }
    }
}
