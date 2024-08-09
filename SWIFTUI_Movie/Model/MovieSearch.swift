//
//  MovieSearch.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/9/24.
//

import Foundation

enum MovieSearchType: String, CaseIterable {
    case movieName = "영화 이름"
    case directorName = "감독 이름"
    
    var placeHolderText: String {
        switch self {
        case .directorName: "관심있는 감독 검색하기"
        case .movieName: "관심있는 영화 검색하기"
        }
    }
}

struct MovieSearch: Equatable, Decodable, Hashable {
    let result: MovieSearchResult
    
    enum CodingKeys: String, CodingKey {
        case result = "movieListResult"
    }
}

struct MovieSearchResult: Equatable, Decodable, Hashable {
    let movieDetailList: [MovieSearchDetail]
    
    enum CodingKeys: String, CodingKey {
        case movieDetailList = "movieList"
    }
}

struct MovieSearchDetail: Equatable, Decodable, Hashable {
    let movieID: String
    let movieName: String
    let openDate: String
    let nation: String
    
    enum CodingKeys: String, CodingKey {
        case movieID = "movieCd"
        case movieName = "movieNm"
        case openDate = "openDt"
        case nation = "nationAlt"
    }
}
