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
    @Dependency (\.movieMemoManager) var memoManager
    @Dependency (\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        let sendedMovieID: String
        var thumnailURL: URL?
        var scrollToMemoRequested: Bool = false
        var detailMovieInfo: KobisMovieInfo?
        var actorInfoLoading: Int?
        var isCompanyViewExpansion: Bool = false
        var movieMemo: MovieDetailMemo? = nil
        
        var popupState: PopupFeature.State?
        @Presents var memoViewState: MovieDetailMemoFeature.State?
    }
    
    enum Action: Equatable {
        case viewInitialized
        case detailInfoUpdate(KobisMovieInfo?)
        case backBtnTapped
        case actorsMoreBtnTapped(KobisMovieInfo)
        case actorTapped(Int)
        case actorDetailInfoRequestSuccess(String)
        case thumnailImageUpdate(URL?)
        case companysMoreViewBtnTapped
        case userDefaultsMemoUpdate
        case memoBtnTapped
        case scrollToMemoSuccss
        case popupShowRequest(AlertModel)
        
        case memoViewAction(PresentationAction<MovieDetailMemoFeature.Action>)
        case popupAction(PopupFeature.Action)
    }
    
    enum PopupID: String, Equatable {
        case actorError
        case viewInit
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                if state.detailMovieInfo != nil, state.popupState == nil {return .none}
                let id = state.sendedMovieID
                return .run(operation: { send in
                    let data = try await self.kobisManager.detailMovieInfoRequest(moiveID: id).movieInfoResult.moiveInfo
                    await  send(.detailInfoUpdate(data))
                }) { error, send in
                    let model = ErrorHandler.getAlertModel(id: PopupID.viewInit.rawValue, error: error, leftBtnTitle: "확인")
                    await send(.popupShowRequest(model))
                }
            case .detailInfoUpdate(let data):
                state.detailMovieInfo = data
                
                if state.thumnailURL == nil && data != nil {
                    return .run(operation: { send in
                        let thumnailData = try? await self.kmdbManager.moiveDetailInfoRequest(title: data!.title, openDate: data!.openDate)
                        await  send(.thumnailImageUpdate(URL(string: thumnailData?.thumbnailURL ?? "")))
                    }) { error, send in
                        print("DETAIL THUMNAIL REQUEST ERROR", error)
                        await send(.userDefaultsMemoUpdate)
                    }
                } else {
                    return .send(.userDefaultsMemoUpdate)
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
                    let alertModel = ErrorHandler.getAlertModel(id: PopupID.actorError.rawValue, error: error, leftBtnTitle: "확인", rightBtnTitle: "재시도")
                    await send(.popupShowRequest(alertModel))
                    print("ERROR", error)
                })
                
            case .thumnailImageUpdate(let url):
                state.thumnailURL = url
                return .send(.userDefaultsMemoUpdate)
                
            case .userDefaultsMemoUpdate:
                guard state.detailMovieInfo != nil else {return .none}
                let memo = self.memoManager.getMovieMemo(forKey: state.sendedMovieID)
                
                if let readMemo = memo {
                    state.movieMemo = readMemo
                }
                
                return .none
                
            case .actorDetailInfoRequestSuccess:
                state.actorInfoLoading = nil
                return .none
                
            case .popupShowRequest(let alertModel):
                state.popupState = .init(alertModel: alertModel)
                return .none
                
            case .companysMoreViewBtnTapped:
                state.isCompanyViewExpansion =  !state.isCompanyViewExpansion
                return .none
                
            case .memoBtnTapped:
                guard let info = state.detailMovieInfo else {return .none}
                
                if state.movieMemo == nil {
                    state.movieMemo = . init(movieID: state.sendedMovieID, movieTitle: info.title, movieNote: "", thumnail: state.thumnailURL)
                }
                state.memoViewState = .init(movieDetailNoteData: state.movieMemo!, insertedValue: state.movieMemo?.movieNote ?? "")
                return .none
                
            case .memoViewAction(.presented(.returnKeyPressed)):
                guard let memo = state.memoViewState?.insertedValue,
                      !memo.isEmpty
                else { // 값이 없거나, 아무런 값을 입력하지 않을 때
                    state.memoViewState = nil
                    state.movieMemo = nil
                    self.memoManager.removeMovieMemo(forKey: state.sendedMovieID)
                    return .none
                }
                state.movieMemo!.movieNote = memo
                self.memoManager.movieMemoSave(data: state.movieMemo!)
                state.memoViewState = nil
                
                return .none
                
            case .scrollToMemoSuccss:
                state.scrollToMemoRequested = false
                return .none
                
            case .popupAction(.leftBtnTapped):
                state.actorInfoLoading = nil
                state.popupState = nil
                guard let popupState = state.popupState, let type = PopupID(rawValue: popupState.alertModel.id) else {return .none}
                if case .viewInit = type {
                    return .run { _ in
                        await self.dismiss()
                    }
                } else {
                    return .none
                }
                
            case .popupAction(.rightBtnTapped):
                let actorIndex = state.actorInfoLoading
                state.actorInfoLoading = nil
                
                guard let popupState = state.popupState, let type = PopupID(rawValue: popupState.alertModel.id) else {
                    state.popupState = nil
                    return .none
                }
                state.popupState = nil
                
                switch type {
                case.actorError:  return .send(.actorTapped(actorIndex!))
                case .viewInit:  return .none
                }
                
            default: return .none
            }
        }
        .ifLet(\.popupState, action: \.popupAction) {
            PopupFeature()
        }
        .ifLet(\.$memoViewState, action: \.memoViewAction) {
            MovieDetailMemoFeature()
        }
    }
}
