//
//  KMDBMovieDetail.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/29/24.
//

import Foundation

struct KMDBMovieDetail: Decodable, Equatable, Hashable {
    let data: [KMDBMovieDetailData]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct KMDBMovieDetailData: Decodable, Equatable, Hashable {
    let result: [KMDBMovieDetailResult]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

struct KMDBMovieDetailResult: Decodable, Equatable, Hashable {
    let title: String
    let posterURL: String?
    let stillURL: String?
    
    var thumbnailURL: String? {
        posterURL == nil ? stillURL :  posterURL
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case posterURL = "posterUrl"
        case stillURL = "stillUrl"
    }
}
