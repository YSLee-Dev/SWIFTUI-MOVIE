//
//  MovieMemoManagerProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import Foundation

protocol MovieMemoManagerProtocol {
    func getMovieMemoAll() -> [MovieDetailMemo]
    func getMovieMemo(forKey: String) ->MovieDetailMemo?
    func movieMemoSave(data: MovieDetailMemo)
    func removeMovieMemo(forKey: String)
}
