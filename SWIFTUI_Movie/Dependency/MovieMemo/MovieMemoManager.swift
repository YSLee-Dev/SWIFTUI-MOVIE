//
//  MovieMemo.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import Foundation

struct MovieMemoManager: MovieMemoManagerProtocol {
    enum Key: String {
        case saveKey = "SAVEMOIVE"
    }
    
    static var shared = MovieMemoManager()
    let isInit = false
    private init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            MovieMemoManager.shared.nowMemoList =  (try? UserDefaults.standard.loadData(movieID: Key.saveKey.rawValue, modelType: [MovieDetailMemo].self)) ?? []
        }
       
    }
    private var nowMemoList: [MovieDetailMemo] = [] {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UserDefaults.standard.saveData(movieId: Key.saveKey.rawValue, memoModel: MovieMemoManager.shared.nowMemoList)
            }
        }
    }
    
    func getMovieMemoAll() -> [MovieDetailMemo] {
        MovieMemoManager.shared.nowMemoList
    }
    
    func getMovieMemo(forKey: String) ->MovieDetailMemo? {
        MovieMemoManager.shared.nowMemoList.first(where: {
            $0.movieID == forKey
        })
    }
    
    func movieMemoSave(data: MovieDetailMemo) {
        if let matchingIndex = MovieMemoManager.shared.nowMemoList.firstIndex(where: {
            $0.movieID == data.movieID
        }) {
            MovieMemoManager.shared.nowMemoList[matchingIndex] = data
        } else {
            MovieMemoManager.shared.nowMemoList.append(data)
        }
    }
    
    func removeMovieMemo(forKey: String) {
        if let index = MovieMemoManager.shared.nowMemoList.firstIndex(where: {
            $0.movieID == forKey
        }) {
            MovieMemoManager.shared.nowMemoList.remove(at: index)
        }
    }
}
