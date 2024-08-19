//
//  AppFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var homeState: HomeFeature.State
        var totalMemoState: TotalMemoFeature.State
        var nowTappedIndex: Int = 0
    }
    
    enum Action: BindableAction, Equatable {
        case homeAction(HomeFeature.Action)
        case totalMemoAction(TotalMemoFeature.Action)
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.homeState, action: \.homeAction) {
            HomeFeature()
        }
        
        Scope(state: \.totalMemoState, action: \.totalMemoAction) {
            TotalMemoFeature()
        }
    }
}
