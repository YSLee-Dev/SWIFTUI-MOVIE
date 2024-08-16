//
//  UserDefaults+.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {
    func saveData<T: Encodable>(movieId: String, memoModel: T) {
        let data = try? PropertyListEncoder().encode(memoModel)
        UserDefaults.standard.setValue(data, forKey: movieId)
    }
    
    func loadData<T: Decodable>(movieID: String, modelType: T.Type) throws -> T {
        let saveMemo = UserDefaults.standard.data(forKey: movieID)
        
        if let saveMemo = saveMemo {
            if let decodingMemo =  try? PropertyListDecoder().decode(modelType, from: saveMemo) {
                return decodingMemo
            } else {
                throw URLError.init(.cannotDecodeContentData)
            }
        } else {
            throw URLError.init(.cannotWriteToFile)
        }
    }
}
