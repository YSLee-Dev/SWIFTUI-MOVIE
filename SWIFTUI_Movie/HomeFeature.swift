//
//  HomeFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import Foundation
import ComposableArchitecture

// 임시 데이터 struct
struct Temp: Hashable {
    let title: String
    let rank: Int
    let date: String
    let image: URL?
}

@Reducer
struct HomeFeature: Reducer {
    @Dependency(\.kobisManager) var kobisManager
    
    @ObservableState
    struct State: Equatable {
        var yesterdayMoiveList: [BoxOfficeList] = []
        var weekMoiveList: [BoxOfficeList] = []
    }
    
    enum Action: Equatable {
        case searchBarTapped
        case movieTapped
        case viewInitialized
        case listUpdated([BoxOfficeList], BoxOfficeType)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                return .merge(
                    .run { send in
                        do {
                            let data =  try await self.kobisManager.boxOfficeListRequest(boxOfficeType: .yesterday)
                            await send(.listUpdated(data, .yesterday))
                        } catch { error
                            print(error)
                        }
                    },
                    .run { send in
                        do {
                            let data =  try await self.kobisManager.boxOfficeListRequest(boxOfficeType: .week)
                            await send(.listUpdated(data, .week))
                        } catch { error
                            print(error)
                        }
                    }
                )
                
            case .listUpdated(let data, let type):
                if type == .week {
                    state.weekMoiveList = data
                } else {
                    state.yesterdayMoiveList = data
                }
                return .none
                
            default: return .none
            }
        }
    }
}
