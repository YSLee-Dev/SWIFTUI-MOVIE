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
    private init() {}
    private var nowMemoList: [MovieDetailMemo] = [] {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UserDefaults.standard.saveData(movieId: Key.saveKey.rawValue, memoModel: MovieMemoManager.shared.nowMemoList)
            }
        }
    }

    // 프로토콜 내부에서는 사용할 수 없음
    func shardValueInit() {
        MovieMemoManager.shared.nowMemoList =  (try? UserDefaults.standard.loadData(movieID: Key.saveKey.rawValue, modelType: [MovieDetailMemo].self)) ?? []
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

struct MovieMemoPreviewManager: MovieMemoManagerProtocol {
    private init() {}
    static var shared = MovieMemoPreviewManager()
    
    private var tempMemoDataList: [MovieDetailMemo] = [
        .init(movieID: "1", movieTitle: "범죄도시", movieNote: "범죄도시는 재미있다. 그냥 뭔가 사람을 재미있게 하는 재주가 있다.", thumnail: nil),
        .init(movieID: "2", movieTitle: "파일럿", movieNote: "재미있었지만, 뭔가 슬펐다..", thumnail: nil),
        .init(movieID: "3", movieTitle: "7번방의 선물", movieNote: "눈물을 엄청 흘려서 머리가 아팠다.\n다시 보고 싶다.", thumnail: nil),
        .init(movieID: "4", movieTitle: "스파이더맨", movieNote: "재미는 있었지만 머리가 아팠다.", thumnail: nil),
        .init(movieID: "5", movieTitle: "극한직업", movieNote: "수원왕갈비치킨이 먹고싶어졌다.\n나중에 해먹어봐야겠다\n꿀잼!", thumnail: nil),
        .init(movieID: "6", movieTitle: "도둑들", movieNote: "그다지 재미가 없었다. ", thumnail: nil)
    ]
    
    func getMovieMemoAll() -> [MovieDetailMemo] {
        MovieMemoPreviewManager.shared.tempMemoDataList
    }
    
    func getMovieMemo(forKey: String) -> MovieDetailMemo? {
        MovieMemoPreviewManager.shared.tempMemoDataList.first(where:{
            $0.movieID == forKey
        })
    }
    
    func movieMemoSave(data: MovieDetailMemo) {
        if let matchingIndex = MovieMemoPreviewManager.shared.tempMemoDataList.firstIndex(where: {
            $0.movieID == data.movieID
        }) {
            MovieMemoPreviewManager.shared.tempMemoDataList[matchingIndex] = data
        } else {
            MovieMemoPreviewManager.shared.tempMemoDataList.append(data)
        }
    }
    
    func removeMovieMemo(forKey: String) {
        if let index = MovieMemoPreviewManager.shared.tempMemoDataList.firstIndex(where: {
            $0.movieID == forKey
        }) {
            MovieMemoPreviewManager.shared.tempMemoDataList.remove(at: index)
        }
    }
}
