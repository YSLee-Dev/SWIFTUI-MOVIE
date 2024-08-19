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
    @ObservableState
    struct State: Equatable {
        
    }
    
    struct Action: Equatable {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
