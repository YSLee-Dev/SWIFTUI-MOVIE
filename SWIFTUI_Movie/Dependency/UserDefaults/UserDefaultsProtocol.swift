//
//  UserDefaultsProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

protocol UserDefaultsProtocol {
    func saveMovieNote<T: Encodable>(movieId: String, memoModel: T) 
    func loadMovieNote<T: Decodable>(movieID: String) throws -> T
}
