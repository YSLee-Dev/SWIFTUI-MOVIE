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
        case yesterdayBoxOffice, weekBoxOffice, detail
    }
    
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [BoxOfficeList] {
        var urlComponents = self.urlComponentsCreate(type: boxOfficeType == .week ? .weekBoxOffice : .yesterdayBoxOffice)
        urlComponents?.queryItems =  [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "targetDt", value: self.createDate(type: boxOfficeType == .week ? .weekBoxOffice : .yesterdayBoxOffice))
        ]
       let data =  try await NetworkManager.shared.reqeustData(decodingType: BoxofficeMovie.self, url: urlComponents?.url).boxOfficeResult
        return (boxOfficeType == .week ? data.weeklyBoxOfficeList : data.dailyBoxOfficeList) ?? []
    }
    
    func detailMovieInfoRequest(moiveID: String)  async throws -> KobisMoiveDetail {
        var urlComponents = self.urlComponentsCreate(type: .detail)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "movieCd", value: moiveID)
        ]
        
        return try await NetworkManager.shared.reqeustData(decodingType: KobisMoiveDetail.self, url: urlComponents?.url)
    }
    
    private func urlComponentsCreate(type: ReqeustType) -> URLComponents? {
        let urlString = switch type {
        case .yesterdayBoxOffice: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        case .weekBoxOffice: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json"
        case .detail: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
        }
        return URLComponents(string: urlString)
    }
    
    private func createDate(type: ReqeustType) -> String {
        let now = Calendar.current.date(byAdding: DateComponents(day: type == .weekBoxOffice ? -7 : -1), to: .now)!
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)
        let day = Calendar.current.component(.day, from: now)
        return "\(year)\(month < 10 ? "0" : "")\(month)\(day)"
    }
}

struct KobisPreviewManager: KobisManagerProtocol {
    func detailMovieInfoRequest(moiveID: String) async throws -> KobisMoiveDetail {
        return .init(movieInfoResult: .init(moiveInfo: .init(title: "범죄도시", movieTotalMin: "120", openDate: "2024년 01월 01일", nations: [.init(name: "한국")], genres: [.init(name: "액션")], actors: [.init(name: "마동석", englishName: "MA", cast: "주인공")])))
    }
    
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [BoxOfficeList] {
        return [
            BoxOfficeList(id: "1", title: "범죄도시", openDate: "2024년 01월 01일", rank: "1"),
            BoxOfficeList(id: "2", title: "극한직업", openDate: "2024년 02월 11일", rank: "1"),
            BoxOfficeList(id: "3", title: "짱구는 못말려 극장판", openDate: "2024년 03월 21일", rank: "1"),
            BoxOfficeList(id: "4", title: "알라딘", openDate: "2024년 04월 02일", rank: "1"),
            BoxOfficeList(id: "5", title: "7번방의 꿈", openDate: "2024년 05월 12일", rank: "1"),
            BoxOfficeList(id: "6", title: "스파이더맨", openDate: "2024년 06월 13일", rank: "1")
        ]
    }
}
