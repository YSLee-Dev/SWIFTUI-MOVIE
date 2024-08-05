//
//  KobisManagerProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/26/24.
//

import Foundation

enum BoxOfficeType { case yesterday, week }

protocol KobisManagerProtocol {
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [BoxOfficeList]
    func detailMovieInfoRequest(moiveID: String)  async throws -> KobisMoiveDetail 
    func actorListSearchRequest(actorName: String, movieName: String, requestPage: Int) async throws -> [SearchActorDetail]
    func actorDetailReqeust(actorID: String) async throws -> ActorDetailInfo
}
