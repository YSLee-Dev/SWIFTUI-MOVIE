//
//  BoxofficeMovie.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation

struct BoxofficeMovie: Decodable, Equatable, Hashable {
    let boxOfficeResult: BoxOfficeResult
 
    enum CodingKeys: String, CodingKey {
        case boxOfficeResult = "boxOfficeResult"
    }
}

struct BoxOfficeResult: Decodable, Equatable, Hashable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]?
    let weeklyBoxOfficeList: [DailyBoxOfficeList]?
 
    enum CodingKeys: String, CodingKey {
        case dailyBoxOfficeList = "dailyBoxOfficeList"
        case weeklyBoxOfficeList = "weeklyBoxOfficeList"
    }
}

struct DailyBoxOfficeList: Decodable, Equatable, Hashable {
    let title: String
    let openDate: String
    let rank: String
    
    enum CodingKeys: String, CodingKey {
        case title = "movieNm"
        case openDate = "openDt"
        case rank = "rank"
    }
}
