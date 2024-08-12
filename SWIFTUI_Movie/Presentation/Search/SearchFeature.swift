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
    @Dependency (\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var searchQuery: String = ""
        var searchResult: [MovieSearchDetail] = []
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
                
            case .movieSearchSuccess(let data):
                state.searchResult.append(contentsOf: data.result.movieDetailList)
                state.nowPage += 1
                state.nowSearching = false
                state.totalCount = data.result.totalCount
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
