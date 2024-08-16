//
//  UserDefaults+.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {
    func saveMovieNote(movieId: String, memo: String) {
        UserDefaults.standard.setValue(memo, forKey: movieId)
    }
    
    func loadMovieNote(movieID: String) throws -> String {
       let saveMemo = UserDefaults.standard.value(forKey: movieID)
        
        if let saveMemo = saveMemo {
            if let stringMemo = saveMemo as? String {
                return stringMemo
            } else {
                throw URLError.init(.cannotDecodeContentData)
            }
        } else {
            throw URLError.init(.cannotWriteToFile)
        }
    }
}
