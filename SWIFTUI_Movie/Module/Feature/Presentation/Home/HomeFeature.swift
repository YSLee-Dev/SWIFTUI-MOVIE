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
        var popupState: PopupFeature.State?
        var popupWaiting: [AlertModel] = []
    }
    
    enum Action: Equatable {
        case searchBarTapped
        case movieTapped(BoxOfficeType, Int)
        case viewInitialized
        case thumbnailURLRequest([BoxOfficeList], BoxOfficeType)
        case listUpdated([HomeModel], BoxOfficeType)
        case popupShowRequest(AlertModel)
        case popupAction(PopupFeature.Action)
    }
    
    enum PopupID: String, Equatable {
        case week, yesterday
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewInitialized:
                if !state.yesterdayMoiveList.isEmpty, !state.weekMoiveList.isEmpty {return .none}
                return .merge(
                    .run(operation: { send in
                        let data =  try await self.kobisManager.boxOfficeListRequest(boxOfficeType: .yesterday)
                        await send(.thumbnailURLRequest(data, .yesterday))
                    }) { error, send in
                        let alertModel = ErrorHandler.getAlertModel(id: PopupID.yesterday.rawValue, error: error, leftBtnTitle: "재시도")
                        await send(.popupShowRequest(alertModel))
                    },
                    .run(operation: { send in
                        let data =  try await self.kobisManager.boxOfficeListRequest(boxOfficeType: .week)
                        await send(.thumbnailURLRequest(data, .week))
                    }) { error, send in
                        let alertModel = ErrorHandler.getAlertModel(id: PopupID.week.rawValue, error: error, leftBtnTitle: "재시도")
                        await  send(.popupShowRequest(alertModel))
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
            
            case .popupShowRequest(let model):
                if state.popupState == nil {
                    state.popupState = .init(alertModel: model)
                } else {
                    state.popupWaiting.append(model)
                }
                return .none
                
            case .popupAction(.leftBtnTapped):
                let nowPopupType = PopupID(rawValue: state.popupState!.alertModel.id)!
                let isNowTypeInit = nowPopupType == .week || nowPopupType == .yesterday
                state.popupState = nil
                
                if !state.popupWaiting.isEmpty {
                    for _ in 0 ..< state.popupWaiting.count {
                        let model = state.popupWaiting.removeFirst()
                        let modelType = PopupID(rawValue: model.id)!
                        
                        if isNowTypeInit {
                            if modelType == .week || modelType == .yesterday {
                                continue
                            } else { // 이전 타입은 init, 현재 타입은 init이 아닌 경우
                                return .merge(
                                    .send(.viewInitialized),
                                    .send(.popupShowRequest(model))
                                )
                            }
                        } else {
                            // init이 아닌 경우
                            switch modelType { // 현재는 init 관련 팝업만 있기 떄문에 임시
                            default: return .merge(
                                .send(.popupShowRequest(model))
                            )
                            }
                        }
                        
                    }
                    // 전부 init 관련 팝업이였을 떄는 팝업 웨이팅 배열을 전부 없애고, init 로드
                    return .send(.viewInitialized)
                   
                } else {
                    switch nowPopupType { // 현재는 init 관련 팝업만 있기 떄문에 임시
                    default: return .send(.viewInitialized)
                    }
                }
                
            default: return .none
            }
        }
        .ifLet(\.popupState, action: \.popupAction) {
            PopupFeature()
        }
    }
}
