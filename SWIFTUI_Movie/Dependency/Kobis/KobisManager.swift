//
//  KobisManager.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation

struct KobisManager: KobisManagerProtocol {
    private init() {}
    static let shaerd = KobisManager() // 싱글톤
    
    private let token = Bundle.main.tokenLoad(.kobis)
    
    enum ReqeustType {
        case boxOffice, detail
    }
    
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [DailyBoxOfficeList] {
        var urlComponents = self.urlComponentsCreate(type: .boxOffice)
        urlComponents?.queryItems =  [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "targetDt", value: self.todayDate())
        ]
        
        return try await NetworkManager.shared.reqeustData(decodingType: BoxofficeMovie.self, url: urlComponents?.url).boxOfficeResult.dailyBoxOfficeList
    }
    
    private func urlComponentsCreate(type: ReqeustType) -> URLComponents? {
        let urlString = switch type {
        case .boxOffice: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        case .detail: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json"
        }
        return URLComponents(string: urlString)
    }
    
    private func todayDate() -> String {
        let year = Calendar.current.component(.year, from: .now)
        let month = Calendar.current.component(.month, from: .now)
        let day = Calendar.current.component(.day, from: Calendar.current.date(byAdding: DateComponents(day: -1), to: .now)!)
        return "\(year)\(month < 10 ? "0" : "")\(month)\(day)"
    }
}

struct KobisPreviewManager: KobisManagerProtocol {
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [DailyBoxOfficeList] {
        return [
            DailyBoxOfficeList(title: "범죄도시", openDate: "2024년 01월 01일", rank: "1"),
            DailyBoxOfficeList(title: "극한직업", openDate: "2024년 02월 11일", rank: "1"),
            DailyBoxOfficeList(title: "짱구는 못말려 극장판", openDate: "2024년 03월 21일", rank: "1"),
            DailyBoxOfficeList(title: "알라딘", openDate: "2024년 04월 02일", rank: "1"),
            DailyBoxOfficeList(title: "7번방의 꿈", openDate: "2024년 05월 12일", rank: "1"),
            DailyBoxOfficeList(title: "스파이더맨", openDate: "2024년 06월 13일", rank: "1")
        ]
    }
}
