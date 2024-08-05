//
//  ActorDetailFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ActorDetailFeature: Reducer {
    @Dependency (\.dismiss) var dismiss
    @Dependency (\.kobisManager) var kobisManager
    
    @ObservableState
    struct State: Equatable {
        let actorID: String
        var actorDetailInfo: ActorDetailInfo?
    }
    
    enum Action: Equatable {
        case viewInitialized
        case actorDetailRequestSuccess(ActorDetailInfo)
        case backBtnTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                let actorID = state.actorID
                return .run(operation: { send in
                    let data = try  await self.kobisManager.actorDetailReqeust(actorID: actorID)
                    await send(.actorDetailRequestSuccess(data))
                },catch: { error, send in
                    // TODO: 데이터가 로드되지 않았을 때 오류처리
                })
                
            case .backBtnTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
            case .actorDetailRequestSuccess(let data):
                state.actorDetailInfo = data
                return .none
            }
        }
    }
}
