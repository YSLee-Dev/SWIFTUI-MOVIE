//
//  SearchModel.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/12/24.
//

import Foundation

struct SearchModel: Equatable {
    let movieID: String
    let movieName: String
    let openDate: String
    let nation: String
    let directors: [String]
    var thumnail: String?
    
    var url: URL? {
        if thumnail == nil {
            return nil
        } else {
            return URL(string: thumnail!)
        }
    }
}
