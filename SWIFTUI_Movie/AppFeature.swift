//
//  AppFeature.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var homeState: HomeFeature.State
        var totalMemoState: TotalMemoFeature.State
        var nowTappedIndex: Int = 0
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction, Equatable {
        case homeAction(HomeFeature.Action)
        case totalMemoAction(TotalMemoFeature.Action)
        case binding(BindingAction<State>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.homeState, action: \.homeAction) {
            HomeFeature()
        }
        
        Scope(state: \.totalMemoState, action: \.totalMemoAction) {
            TotalMemoFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .detailAction(.actorsMoreBtnTapped(let info)))):
                state.path.append(.detailActorsState(.init(moiveTitle: info.title, actorList: info.actors)))
                return .none
                
            case .path(.element(id: _, action: .detailAction(.actorDetailInfoRequestSuccess(let actorID)))):
                state.path.append(.actorDetailState(.init(actorID: actorID)))
                return .send(.path(.element(id: state.path.ids[state.path.ids.count - 2], action: .detailActorsAction(.actorDetailInfoRequestEND)))) // 만약 등장인물 상세보기가 열려있었다면
                
            case .path(.element(id: _, action: .detailActorsAction(.actorTapped(let index)))):
                // 배우 더보기는 movieDetail을 무조건 통해야하기 때문에 count로 최근 열린 movieDetail 확인
                return .send(.path(.element(id: state.path.ids[state.path.ids.count - 2], action: .detailAction(.actorTapped(index)))))
                
            case .path(.element(id: _, action: .actorDetailAction(.movieTapped(let id)))):
                state.path.append(.detailState(.init(sendedMovieID: id)))
                return .none
                
            case .path(.element(id: _, action: .searchAction(.movieTapped(let id)))):
                state.path.append(.detailState(.init(sendedMovieID: id)))
                return .none
                
            case .totalMemoAction(.memoTapped(let index)):
                let tappedData = state.totalMemoState.nowMemoList[index]
                state.path.append(.detailState(.init(sendedMovieID: tappedData.movieID, thumnailURL: tappedData.thumnail, scrollToMemoRequested: true)))
                return .none
                
            case .homeAction(.searchBarTapped):
                state.path.append(.searchState(.init()))
                return .none
                
            case .homeAction(.movieTapped(let type, let index)):
                let tappedData = type == .week ? state.homeState.weekMoiveList[index] : state.homeState.yesterdayMoiveList[index]
                state.path.append(.detailState(.init(sendedMovieID: tappedData.moiveID, thumnailURL: tappedData.url)))
                return .none
                
            default: return .none
            }
        }
        
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

extension AppFeature {
    @Reducer
    struct Path: Reducer {
        @ObservableState
        enum State: Equatable {
            case detailState(DetailFeature.State)
            case detailActorsState(DetailActorsFeature.State)
            case actorDetailState(ActorDetailFeature.State)
            case searchState(SearchFeature.State)
        }
        
        enum Action: Equatable {
            case detailAction(DetailFeature.Action)
            case detailActorsAction(DetailActorsFeature.Action)
            case actorDetailAction(ActorDetailFeature.Action)
            case searchAction(SearchFeature.Action)
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
            
            Scope(state: \.searchState, action: \.searchAction) {
                SearchFeature()
            }
        }
    }
}
