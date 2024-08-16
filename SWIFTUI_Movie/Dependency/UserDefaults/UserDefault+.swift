//
//  UserDefaults+.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {
    func saveMovieNote<T: Encodable>(movieId: String, memoModel: T) {
        let data = try? PropertyListEncoder().encode(memoModel)
        UserDefaults.standard.setValue(data, forKey: movieId)
    }
    
    func loadMovieNote<T: Decodable>(movieID: String) throws -> T {
        let saveMemo = UserDefaults.standard.data(forKey: movieID)
        
        if let saveMemo = saveMemo {
            if let decodingMemo =  try? PropertyListDecoder().decode(T.self, from: saveMemo) {
                return decodingMemo
            } else {
                throw URLError.init(.cannotDecodeContentData)
            }
        } else {
            throw URLError.init(.cannotWriteToFile)
        }
    }
}
