//
//  PopupFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/22/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PopupFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        let alertModel: AlertModel
        
        let leftBtnTitle: String
        let rightBtntTitle: String?
    }
    
    enum Action: Equatable {
        case leftBtnTapped
        case rightBtnTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
