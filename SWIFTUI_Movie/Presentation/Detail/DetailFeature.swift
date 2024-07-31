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
    @ObservableState
    struct State: Equatable {
        let movieID: String
        let tappedData: HomeModel
    }
    
    enum Action: Equatable {
        case viewInitialized
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
