//
//  ActorDetailFilmoModel.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/5/24.
//

import Foundation

struct ActorDetailFilmoModel:  Equatable, Hashable {
    let movieID: String
    let movieTitle: String
    let role: String
    var thumbnailURL: String?
    
    var url: URL? {
        if thumbnailURL == nil {
            return nil
        } else {
           return URL(string: thumbnailURL!)
        }
    }
}
