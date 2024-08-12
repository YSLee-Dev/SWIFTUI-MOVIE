//
//  HomeModel.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/29/24.
//

import Foundation

struct HomeModel: Equatable, Hashable {
    let title: String
    let openDate: String
    let rank: String
    var thumbnailURL: String?
    let moiveID: String
    
    init(title: String, openDate: String, rank: String, thumbnailURL: String? = nil, movieID: String) {
        self.title = title
        self.openDate = openDate
        self.rank = rank
        self.thumbnailURL = thumbnailURL
        self.moiveID = movieID
    }
    
    var url: URL? {
        if thumbnailURL == nil {
            return nil
        } else {
           return URL(string: thumbnailURL!)
        }
    }
}
