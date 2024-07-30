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
        let urlString = posterURL == nil ? stillURL :  posterURL
        if let firstIndex = urlString?.firstIndex(of: "|"),  urlString != nil {
            return String(urlString![urlString!.startIndex ..< firstIndex])
        } else {
            return urlString
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case posterURL = "posters"
        case stillURL = "stlls"
    }
}
