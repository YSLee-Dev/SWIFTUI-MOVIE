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
    }
    
    enum Action:  BindableAction, Equatable {
        case binding(BindingAction<State>)
        case movieSearchSuccess([MovieSearchDetail])
        case movieTapped(String)
        case backBtnTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.searchQuery):
                let nowState = state
                
                if state.searchQuery.isEmpty {return .none}
                
                return .run(operation: { send in
                    let data = try await self.kobisManager.movieSearchRequest(query: nowState.searchQuery, movieSearchType: nowState.searchType)
                    await send(.movieSearchSuccess(data))
                }) { error, send in
                    // TODO: Error 처리
                }
                
            case .movieSearchSuccess(let data):
                state.searchResult = data
                return .none
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            default:
                return .none
            }
        }
    }
}
