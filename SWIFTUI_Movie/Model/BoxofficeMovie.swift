//
//  BoxofficeMovie.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation

struct BoxofficeMovie: Decodable, Equatable {
    let boxOfficeResult: BoxOfficeResult
 
    enum CodingKeys: String, CodingKey {
        case boxOfficeResult = "boxOfficeResult"
    }
}

struct BoxOfficeResult: Decodable, Equatable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
 
    enum CodingKeys: String, CodingKey {
        case dailyBoxOfficeList = "dailyBoxOfficeList"
    }
}

struct DailyBoxOfficeList: Decodable, Equatable {
    let title: String
    let openDate: String
    let rank: String
    
    enum CodingKeys: String, CodingKey {
        case title = "movieNm"
        case openDate = "openDt"
        case rank = "rank"
    }
}
