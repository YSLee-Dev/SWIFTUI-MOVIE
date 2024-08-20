//
//  TotalMemoFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TotalMemoFeature: Reducer {
    @Dependency (\.movieMemoManager) var memoManager
    
    @ObservableState
    struct State: Equatable {
        var nowMemoList: [MovieDetailMemo] = []
    }
    
    enum Action: Equatable {
        case viewShowed
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewShowed:
                state.nowMemoList = self.memoManager.getMovieMemoAll()
                return .none
            }
        }
    }
}
