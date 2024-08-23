//
//  SearchActor.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/4/24.
//

import Foundation

struct SearchActor: Decodable, Equatable, Hashable {
    let actorList: SearchActorList
    
    enum CodingKeys: String, CodingKey {
        case actorList = "peopleListResult"
    }
}

struct SearchActorList: Decodable, Equatable, Hashable {
    let actorDetailList: [SearchActorDetail]
    
    enum CodingKeys: String, CodingKey {
        case actorDetailList = "peopleList"
    }
}

struct SearchActorDetail: Decodable, Equatable, Hashable {
    let name: String
    let id: String
    let filmoList: String
    
    enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
        case id = "peopleCd"
        case filmoList = "filmoNames"
    }
}
