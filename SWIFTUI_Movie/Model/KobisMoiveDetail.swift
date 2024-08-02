//
//  KobisMoiveDetail.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/31/24.
//

import Foundation

struct KobisMoiveDetail: Decodable, Equatable, Hashable {
    let movieInfoResult: KobisMovieInfoResult
    
    enum CodingKeys: String, CodingKey {
        case movieInfoResult = "movieInfoResult"
    }
}

struct KobisMovieInfoResult: Decodable, Equatable, Hashable {
    let moiveInfo: KobisMovieInfo
    
    enum CodingKeys: String, CodingKey {
        case moiveInfo = "movieInfo"
    }
}

struct KobisMovieInfo: Decodable, Equatable, Hashable {
    let title: String
    let movieTotalMin: String
    let openDate: String
    let nations: [KobisMovieInfoNations]
    let genres: [KobisMovieInfoGenres]
    let actors: [KobisMovieInfoActors]
    let companys: [KobisMovieInfoCompanys]
    let directors: [KobisMovieInfoDirectors]
    
    enum CodingKeys: String, CodingKey {
        case title = "movieNm"
        case movieTotalMin = "showTm"
        case openDate = "openDt"
        case nations = "nations"
        case genres = "genres"
        case actors = "actors"
        case companys = "companys"
        case directors = "directors"
    }
}

struct KobisMovieInfoNations: Decodable, Equatable, Hashable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "nationNm"
    }
}

struct KobisMovieInfoGenres: Decodable, Equatable, Hashable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "genreNm"
    }
}

struct KobisMovieInfoActors: Decodable, Equatable, Hashable {
    let name: String
    let englishName: String
    let cast: String
    
    enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
        case englishName = "peopleNmEn"
        case cast = "cast"
    }
}

struct KobisMovieInfoCompanys: Decodable, Equatable, Hashable {
    let name: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case name = "companyNm"
        case type = "companyPartNm"
    }
}

struct KobisMovieInfoDirectors: Decodable, Equatable, Hashable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
    }
}
