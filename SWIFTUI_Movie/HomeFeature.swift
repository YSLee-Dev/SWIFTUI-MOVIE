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
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        case searchBarTapped
        case movieTapped(BoxOfficeType, Int)
        case viewInitialized
        case thumbnailURLRequest([BoxOfficeList], BoxOfficeType)
        case listUpdated([HomeModel], BoxOfficeType)
        case path(StackAction<Path.State, Path.Action>)
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
             
            case .movieTapped(let type, let index):
                let tappedData = type == .week ? state.weekMoiveList[index] : state.yesterdayMoiveList[index]
                state.path.append(.detailState(.init(sendedMovieID: tappedData.moiveID, thumnailURL: tappedData.url)))
                return .none
                
            case .path(.element(id: _, action: .detailAction(.actorsMoreBtnTapped(let info)))):
                state.path.append(.detailActorsState(.init(moiveTitle: info.title, actorList: info.actors)))
                return .none
                
            case .path(.element(id: _, action: .detailAction(.actorDetailInfoRequestSuccess(let actorID)))):
                state.path.append(.actorDetailState(.init(actorID: actorID)))
                return .send(.path(.element(id: state.path.ids[state.path.ids.count - 2], action: .detailActorsAction(.actorDetailInfoRequestEND)))) // 만약 등장인물 상세보기가 열려있었다면
                
            case .path(.element(id: let pathID, action: .detailAction(.actorDetailInfoRequestFailed(_)))):
                if state.path.ids.last != pathID {
                    state.path.removeLast()
                }
                return .none
                
            case .path(.element(id: _, action: .detailActorsAction(.actorTapped(let index)))):
                // 배우 더보기는 movieDetail을 무조건 통해야하기 때문에 count로 최근 열린 movieDetail 확인
                return .send(.path(.element(id: state.path.ids[state.path.ids.count - 2], action: .detailAction(.actorTapped(index)))))
                
            case .path(.element(id: _, action: .actorDetailAction(.movieTapped(let id)))):
                state.path.append(.detailState(.init(sendedMovieID: id)))
                return .none
            
            default: return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

extension HomeFeature {
    @Reducer
    struct Path: Reducer {
        @ObservableState
        enum State: Equatable {
            case detailState(DetailFeature.State)
            case detailActorsState(DetailActorsFeature.State)
            case actorDetailState(ActorDetailFeature.State)
        }
        
        enum Action: Equatable {
            case detailAction(DetailFeature.Action)
            case detailActorsAction(DetailActorsFeature.Action)
            case actorDetailAction(ActorDetailFeature.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.detailState, action: \.detailAction) {
               DetailFeature()
            }
            
            Scope(state: \.detailActorsState, action: \.detailActorsAction) {
                DetailActorsFeature()
            }
            
            Scope(state: \.actorDetailState, action: \.actorDetailAction) {
                ActorDetailFeature()
            }
        }
    }
}
