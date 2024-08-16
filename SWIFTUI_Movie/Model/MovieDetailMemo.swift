//
//  MovieDetailNote.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

struct MovieDetailMemo: Codable, Equatable {
    let movieID: String
    let movieTitle: String
    var movieNote: String
    let thumnail: URL?
}
