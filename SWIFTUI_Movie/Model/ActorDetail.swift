//
//  ActorDetail.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/5/24.
//

import Foundation

struct ActorDetail: Decodable, Equatable, Hashable {
    let result: ActorDetailInfoResult
    
    enum CodingKeys: String, CodingKey {
        case result = "peopleInfoResult"
    }
}

struct ActorDetailInfoResult: Decodable, Equatable, Hashable {
    let actorInfo: ActorDetailInfo
    
    enum CodingKeys: String, CodingKey {
        case actorInfo = "peopleInfo"
    }
}

struct ActorDetailInfo: Decodable, Equatable, Hashable {
    let name: String
    let englishName: String
    let sex: String
    let role: String
    let filmos: [ActorDetailInfoFilmos]
    
    var totalName: String {
        return englishName.isEmpty ? "\(name)" : "\(name) (\(englishName))"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
        case englishName = "peopleNmEn"
        case sex = "sex"
        case role = "repRoleNm"
        case filmos = "filmos"
    }
}

struct ActorDetailInfoFilmos: Decodable, Equatable, Hashable {
    let movieID: String
    let movieTitle: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case movieID = "movieCd"
        case movieTitle = "movieNm"
        case role = "moviePartNm"
    }
}
