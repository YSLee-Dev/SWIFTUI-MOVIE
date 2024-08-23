//
//  MovieDetailMemoFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieDetailMemoFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        let movieDetailNoteData: MovieDetailMemo
        var insertedValue: String = ""
    }
    
    enum Action:  BindableAction, Equatable {
        case binding(BindingAction<State>)
        case returnKeyPressed
        case backBtnTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
