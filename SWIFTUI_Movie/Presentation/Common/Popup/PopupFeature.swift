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
        var isShow: Bool = false
    }
    
    enum Action: Equatable {
        case leftBtnTapped
        case rightBtnTapped
        case btnsTapped(Bool)
        case viewOnAppear
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewOnAppear:
                state.isShow = true
                return .none
                
            case .btnsTapped(let isLeft):
                state.isShow = false
                return .run { send in
                   try! await Task.sleep(for: .milliseconds(200))
                    
                    if isLeft {
                        await send(.leftBtnTapped)
                    } else {
                        await send(.rightBtnTapped)
                    }
                }
            default:
                return .none
            }
        }
    }
}
