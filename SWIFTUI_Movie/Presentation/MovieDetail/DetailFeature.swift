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
    @Dependency (\.kmdbManager) var kmdbManager
    @Dependency (\.kobisManager) var kobisManager
    @Dependency (\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        let sendedMovieID: String
        var thumnailURL: URL?
        var detailMovieInfo: KobisMovieInfo?
        var actorInfoLoading: Int?
        @Presents var alertState: AlertState<Action.Alert>?
    }
    
    
    enum Action: Equatable {
        case viewInitialized
        case detailInfoUpdate(KobisMovieInfo?)
        case backBtnTapped
        case actorsMoreBtnTapped(KobisMovieInfo)
        case actorTapped(Int)
        case actorDetailInfoRequestSuccess(String)
        case actorDetailInfoRequestFailed(AlertModel)
        case thumnailImageUpdate(URL?)
        case alertAction(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case cancelBtnTap
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                if state.detailMovieInfo != nil {return .none}
                let id = state.sendedMovieID
                return .run { send in
                    let data = try? await self.kobisManager.detailMovieInfoRequest(moiveID: id).movieInfoResult.moiveInfo
                    await  send(.detailInfoUpdate(data))
                }
                
            case .detailInfoUpdate(let data):
                state.detailMovieInfo = data
                
                if state.thumnailURL == nil && data != nil {
                    return .run { send in
                        let thumnailData = try? await self.kmdbManager.moiveDetailInfoRequest(title: data!.title, openDate: data!.openDate)
                        await  send(.thumnailImageUpdate(URL(string: thumnailData?.thumbnailURL ?? "")))
                    }
                } else {
                    return .none
                }
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .actorTapped(let index):
                guard let detailInfo = state.detailMovieInfo else {return .none}
                state.actorInfoLoading = index
                let tappedActor = detailInfo.actors[index]
                
                return .run(operation: { send in
                    let actorData = try await self.kobisManager.actorListSearchRequest(actorName: tappedActor.name, movieName: detailInfo.title, requestPage: 1)
                    // 이름 일치여부 + 영화 일치여부
                    let filtered = actorData.filter {$0.name == tappedActor.name && $0.filmoList.contains(detailInfo.title)}
                    
                    if let first = filtered.first {
                        await send(.actorDetailInfoRequestSuccess(first.id))
                    }
                    
                }, catch: { error, send in
                    let alertModel = ErrorHandler.getAlertModel(error: error)
                    await send(.actorDetailInfoRequestFailed(alertModel))
                    print("ERROR", error)
                })
                
            case .thumnailImageUpdate(let url):
                state.thumnailURL = url
                return .none
                
            case .actorDetailInfoRequestSuccess:
                state.actorInfoLoading = nil
                return .none
                
            case .actorDetailInfoRequestFailed(let alertModel):
                state.actorInfoLoading = nil
                state.alertState = AlertState {
                    TextState(alertModel.title)
                } actions: {
                    ButtonState(role: .cancel){
                        TextState("확인")
                    }
                } message: {
                    TextState(alertModel.msg)
                }
                
                return .none
                
            case .alertAction(.dismiss), .alertAction(.presented(.cancelBtnTap)):
                state.alertState = nil
                return .none
                
            default: return .none
            }
        }
        .ifLet(\.alertState, action: \.alertAction)
    }
}
