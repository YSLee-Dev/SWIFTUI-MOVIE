//
//  DetailFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/30/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailFeature: Reducer {
    
    @Dependency (\.kobisManager) var kobisManager
    
    @ObservableState
    struct State: Equatable {
        let sendedMovieID: String
        let sendedThumnailURL: URL?
        var detailMovieInfo: KobisMovieInfo?
    }
    
    enum Action: Equatable {
        case viewInitialized
        case detailInfoUpdate(KobisMovieInfo?)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                let id = state.sendedMovieID
                return .run { send in
                    let data = try? await kobisManager.detailMovieInfoRequest(moiveID: id).movieInfoResult.moiveInfo
                    await  send(.detailInfoUpdate(data))
                }
                
            case .detailInfoUpdate(let data):
                state.detailMovieInfo = data
                return .none
            }
        }
    }
}