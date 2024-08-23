//
//  SearchFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/9/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature: Reducer {
    @Dependency (\.kobisManager) var kobisManager
    @Dependency (\.kmdbManager) var kmdbManager
    @Dependency (\.dismiss) var dismiss
    
    struct UpdateRequestModel: Equatable {
        let index: Int
        let data: SearchModel
    }
    
    @ObservableState
    struct State: Equatable {
        var searchQuery: String = ""
        var searchResult: [SearchModel] = []
        var searchType: MovieSearchType = .movieName
        var nowSearching: Bool = false
        var nowPage: Int = 0
        var totalCount: Int = 0
        var nowSearchingWord: String? = nil
        var popupState: PopupFeature.State?
    }
    
    enum Action:  BindableAction, Equatable {
        case binding(BindingAction<State>)
        case movieSearchSuccess(MovieSearch)
        case movieTapped(String)
        case backBtnTapped
        case movieSearchTimerEnded
        case movieSearchRequest
        case thumnailRequest([SearchModel])
        case thumnailImageSuccess(UpdateRequestModel)
        case popupShowRequest(AlertModel)
        case popupAction(PopupFeature.Action)
    }
    
    enum TimerKey: Equatable {
        case searchLoad
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.searchQuery):
                if state.searchQuery.isEmpty || state.nowSearchingWord == state.searchQuery {return .none}
                
                if  state.nowSearching {
                    return .concatenate(
                        .cancel(id: TimerKey.searchLoad),
                        .run { send in
                            do {
                                try await Task.sleep(for: .seconds(1)) //1초간 입력이 일어나지 않을 때 로딩 요청
                                await send(.movieSearchTimerEnded)
                            }  catch {
                            }
                        }
                    )
                    .cancellable(id: TimerKey.searchLoad)
                } else {
                    state.nowSearching = true
                     return  .run { send in
                            do {
                                try await Task.sleep(for: .seconds(1)) //1초간 입력이 일어나지 않을 때 로딩 요청
                                await send(.movieSearchTimerEnded)
                            }
                        }
                     .cancellable(id: TimerKey.searchLoad)
                }
                
            case .binding(\.searchType):
                state.nowPage = 0
                state.totalCount = 0
                state.searchResult = []
                state.searchQuery = ""
                state.nowSearchingWord = ""
                return .none
                
            case .movieSearchSuccess(let data):
                let searchModelDataList = data.result.movieDetailList.map { data in SearchModel(movieID: data.movieID, movieName: data.movieName, openDate: data.openDate, nation: data.nation, directors: data.directors.map {$0.name})}
                state.searchResult.append(contentsOf: searchModelDataList)
                state.nowPage += 1
                state.nowSearching = false
                state.totalCount = data.result.totalCount
                state.nowSearchingWord = state.searchQuery
                
                return .send(.thumnailRequest(searchModelDataList))
                
            case .thumnailRequest(let data):
                let nowPage = state.nowPage
                return .concatenate(
                    .cancel(id: TimerKey.searchLoad),
                    .run { send in
                        var searchModelDataList = data
                        
                        for index in searchModelDataList.indices {
                            let thumnail = try? await self.kmdbManager.moiveDetailInfoRequest(title: searchModelDataList[index].movieName, openDate: searchModelDataList[index].openDate)
                            searchModelDataList[index].thumnail = thumnail?.thumbnailURL
                            await send(.thumnailImageSuccess(.init(index: ((nowPage - 1) * 10) + index, data: searchModelDataList[index])))
                        }
                    }
                )
                
            case .thumnailImageSuccess(let model):
                state.searchResult[model.index] = model.data
                return .none
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .movieSearchTimerEnded:
                state.nowPage = 0
                state.totalCount = 0
                state.searchResult = []
                state.nowSearchingWord = state.searchQuery
                
                return .send(.movieSearchRequest)
                
            case .movieSearchRequest:
                let nowState = state
                
                if state.searchQuery.isEmpty || (state.nowPage * 10) > state.totalCount  {
                    return .none
                }
                
                return .run(operation: { send in
                    let data = try await self.kobisManager.movieSearchRequest(query: nowState.searchQuery, movieSearchType: nowState.searchType, requestPage: nowState.nowPage + 1)
                    await send(.movieSearchSuccess(data))
                }) { error, send in
                    let alertModel = ErrorHandler.getAlertModel(id: "", error: error, leftBtnTitle: "확인", rightBtnTitle: "재시도")
                    await send(.popupShowRequest(alertModel))
                }
                
            case .popupShowRequest(let model):
                state.nowSearching = false
                state.popupState = .init(alertModel: model)
                return .none
                
            case .popupAction(.leftBtnTapped):
                state.popupState = nil
                return .none
                
            case .popupAction(.rightBtnTapped):
                state.popupState = nil
                return .send(.movieSearchTimerEnded)
            
            default:
                return .none
            }
        }
        .ifLet(\.popupState, action: \.popupAction) {
            PopupFeature()
        }
    }
}
