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
        @Presents var alertState: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case viewInitialized
        case actorDetailRequestSuccess(ActorDetailInfo)
        case backBtnTapped
        case filmoListRequestSuccess([ActorDetailFilmoModel])
        case filmoListRequestFailed(AlertModel)
        case movieTapped(String)
        case alertAction(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case retryBtnTapped
            case cancelBtnTapped
        }
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
                    let alertModel = ErrorHandler.getAlertModel(error: error)
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
                state.alertState = AlertState {
                    TextState(model.title)
                } actions: {
                    ButtonState(action: .retryBtnTapped) {
                        TextState("재시도")
                    }
                    ButtonState(role: .cancel, action: .cancelBtnTapped) {
                        TextState("취소")
                    }
                }
                return .none
            
            case .alertAction(.presented(.retryBtnTapped)):
                state.alertState = nil
                return .send(.viewInitialized)
                
            case .alertAction(.presented(.cancelBtnTapped)):
                state.alertState = nil
                return .run { _ in
                   await self.dismiss()
                }
                
            default: return .none
            }
        }
        .ifLet(\.alertState, action: \.alertAction)
    }
}
