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
    @Dependency (\.dismiss) var dismiss
    @Dependency (\.kobisManager) var kobisManager
    @Dependency(\.kmdbManager) var kmdbManager
    
    @ObservableState
    struct State: Equatable {
        let actorID: String
        var actorDetailInfo: ActorDetailInfo?
        var filmoList: [ActorDetailFilmoModel] = []
        var popupState: PopupFeature.State?
    }
    
    enum Action: Equatable {
        case viewInitialized
        case actorDetailRequestSuccess(ActorDetailInfo)
        case backBtnTapped
        case filmoListRequestSuccess([ActorDetailFilmoModel])
        case filmoListRequestFailed(AlertModel)
        case movieTapped(String)
        case popupAction(PopupFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                if state.actorDetailInfo != nil  {return .none}
                let actorID = state.actorID
                return .run(operation: { send in
                    let data = try  await self.kobisManager.actorDetailReqeust(actorID: actorID)
                    await send(.actorDetailRequestSuccess(data))
                },catch: { error, send in
                    let alertModel = ErrorHandler.getAlertModel(id: "", error: error, leftBtnTitle: "확인", rightBtnTitle: "재시도")
                    await send(.filmoListRequestFailed(alertModel))
                })
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .actorDetailRequestSuccess(let data):
                state.actorDetailInfo = data
                
                return .run { send in
                    var filmoModels = data.filmos.map {
                        ActorDetailFilmoModel(movieID: $0.movieID, movieTitle: $0.movieTitle, role: $0.role, thumbnailURL: nil)
                    }
                 
                    await send(.filmoListRequestSuccess( filmoModels))
                    
                    for index in 0 ..< data.filmos.count {
                        let movie = data.filmos[index]
                        let thumbnailData = try? await self.kmdbManager.moiveDetailInfoRequest(title: movie.movieTitle, openDate: "")
                        filmoModels[index].thumbnailURL = thumbnailData?.thumbnailURL
                        
                        await send(.filmoListRequestSuccess(filmoModels))
                    }
                }
            case .filmoListRequestSuccess(let filmos):
                state.filmoList = filmos
                return .none
                
            case .filmoListRequestFailed(let model):
                state.popupState = .init(alertModel: model)
                return .none
            
            case .popupAction(.rightBtnTapped):
                state.popupState = nil
                return .send(.viewInitialized)
                
            case .popupAction(.leftBtnTapped):
                state.popupState = nil
                return .run { _ in
                   await self.dismiss()
                }
                
            default: return .none
            }
        }
        .ifLet(\.popupState, action: \.popupAction) {
            PopupFeature()
        }
    }
}
