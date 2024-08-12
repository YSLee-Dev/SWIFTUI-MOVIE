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
    }
    
    enum Action:  BindableAction, Equatable {
        case binding(BindingAction<State>)
        case movieSearchSuccess([MovieSearchDetail])
        case movieTapped(String)
        case backBtnTapped
        case movieSearchTimerEnd
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
                                await send(.movieSearchTimerEnd)
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
                                await send(.movieSearchTimerEnd)
                            } 
                        }
                     .cancellable(id: TimerKey.searchLoad)
                }
                
            case .movieSearchSuccess(let data):
                state.searchResult = data
                state.nowSearching = false
                return .none
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .movieSearchTimerEnd:
                let nowState = state
                
                if state.searchQuery.isEmpty {return .none}
                
                return .run(operation: { send in
                    let data = try await self.kobisManager.movieSearchRequest(query: nowState.searchQuery, movieSearchType: nowState.searchType)
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
