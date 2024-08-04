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
    @Dependency (\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        let sendedMovieID: String
        let sendedThumnailURL: URL?
        var detailMovieInfo: KobisMovieInfo?
    }
    
    enum Action: Equatable {
        case viewInitialized
        case detailInfoUpdate(KobisMovieInfo?)
        case backBtnTapped
        case actorsMoreBtnTapped(KobisMovieInfo)
        case actorTapped(Int)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                let id = state.sendedMovieID
                return .run { send in
                    let data = try? await self.kobisManager.detailMovieInfoRequest(moiveID: id).movieInfoResult.moiveInfo
                    await  send(.detailInfoUpdate(data))
                }
                
            case .detailInfoUpdate(let data):
                state.detailMovieInfo = data
                return .none
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .actorTapped(let index):
                guard let detailInfo = state.detailMovieInfo else {return .none}
                let tappedActor = detailInfo.actors[index]
                
                
                return .run {send in
                    let data = await try? self.kobisManager.actorListSearchRequest(actorName: tappedActor.name, movieName: detailInfo.title, requestPage: 1)
                    print(data)
                }
                
            default: return .none
            }
        }
    }
}
