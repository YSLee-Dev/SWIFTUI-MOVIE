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
    }
    
    enum Action:  BindableAction, Equatable {
        case binding(BindingAction<State>)
        case movieSearchSuccess(MovieSearch)
        case movieTapped(String)
        case backBtnTapped
        case movieSearchTimerEnded
        case morePageLoadingRequest
        case movieSearchRequest
        case thumnailRequest([SearchModel])
        case thumnailImageSuccess(UpdateRequestModel)
    }
    
    enum TimerKey: Equatable {
        case searchLoad
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.searchQuery):
                if state.searchQuery.isEmpty {return .none}
                
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
                return .none
                
            case .movieSearchSuccess(let data):
                var searchModelDataList = data.result.movieDetailList.map { data in SearchModel(movieID: data.movieID, movieName: data.movieName, openDate: data.openDate, nation: data.nation, directors: data.directors.map {$0.name})}
                state.searchResult.append(contentsOf: searchModelDataList)
                state.nowPage += 1
                state.nowSearching = false
                state.totalCount = data.result.totalCount
                
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
                
                return .send(.movieSearchRequest)
                
            case .morePageLoadingRequest:
                if state.searchQuery.isEmpty || (state.nowPage * 10) > state.totalCount  {
                    return .none
                } else {
                    return .send(.movieSearchRequest)
                }
                
            case .movieSearchRequest:
                let nowState = state
                
                return .run(operation: { send in
                    let data = try await self.kobisManager.movieSearchRequest(query: nowState.searchQuery, movieSearchType: nowState.searchType, requestPage: nowState.nowPage + 1)
                    await send(.movieSearchSuccess(data))
                }) { error, send in
                    // TODO: Error 처리
                }
                
            default:
                return .none
            }
        }
    }
}
