//
//  UserDefaultsProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

protocol UserDefaultsProtocol {
    func saveMovieNote(movieId: String, memo: String)
    func loadMovieNote(movieID: String) throws -> String
}
