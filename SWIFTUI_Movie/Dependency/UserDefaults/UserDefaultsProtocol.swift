//
//  UserDefaultsProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

protocol UserDefaultsProtocol {
    func saveData<T: Encodable>(movieId: String, memoModel: T)
    func loadData<T: Decodable>(movieID: String, modelType: T.Type) throws -> T 
}
