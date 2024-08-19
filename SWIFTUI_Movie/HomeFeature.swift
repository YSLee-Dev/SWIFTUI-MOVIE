//
//  HomeFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/24/24.
//

import Foundation
import ComposableArchitecture

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
        case movieTapped(BoxOfficeType, Int)
        case viewInitialized
        case thumbnailURLRequest([BoxOfficeList], BoxOfficeType)
        case listUpdated([HomeModel], BoxOfficeType)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                if !state.yesterdayMoiveList.isEmpty {return .none}
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
                    var homeModelList: [HomeModel] = data.map {.init(title: $0.title, openDate: $0.openDate, rank: $0.rank, movieID: $0.id)}
                    await send(.listUpdated(homeModelList, type))
                    
                    for index in 0 ..< data.count {
                        var movie = homeModelList[index]
                        let thumbnailData = try? await self.kmdbManager.moiveDetailInfoRequest(title: movie.title, openDate: movie.openDate)
                        movie.thumbnailURL = thumbnailData?.thumbnailURL
                        homeModelList[index] = movie
                       
                        await send(.listUpdated(homeModelList, type))
                    }
                }
                
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
