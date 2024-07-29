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
    @Dependency(\.kmdbManager) var kmdbManager
    
    @ObservableState
    struct State: Equatable {
        var yesterdayMoiveList: [HomeModel] = []
        var weekMoiveList: [HomeModel] = []
    }
    
    enum Action: Equatable {
        case searchBarTapped
        case movieTapped
        case viewInitialized
        case thumbnailURLRequest([BoxOfficeList], BoxOfficeType)
        case listUpdated([HomeModel], BoxOfficeType)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                return .merge(
                    .run { send in
                        do {
                            let data =  try await self.kobisManager.boxOfficeListRequest(boxOfficeType: .yesterday)
                            await send(.thumbnailURLRequest(data, .yesterday))
                        } catch { error
                            print(error)
                        }
                    },
                    .run { send in
                        do {
                            let data =  try await self.kobisManager.boxOfficeListRequest(boxOfficeType: .week)
                            await send(.thumbnailURLRequest(data, .week))
                        } catch { error
                            print(error)
                        }
                    }
                )
                
            case .thumbnailURLRequest(let data, let type):
                return .run { send in
                    var homeModelList: [HomeModel] = []
                    for movie in data {
                        let thumbnailData = try? await self.kmdbManager.moiveDetailInfoRequest(title: movie.title, openDate: movie.openDate)
                        homeModelList.append(HomeModel(title: movie.title, openDate: movie.openDate, rank: movie.rank, thumbnailURL: thumbnailData?.thumbnailURL))
                    }
                    await send(.listUpdated(homeModelList, type))
                }
                
            case .listUpdated(let data, let type):
                print(data)
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
