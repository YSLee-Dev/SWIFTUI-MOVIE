//
//  KobisManager.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation

struct KobisManager {
    private init() {}
    static let shaerd = KobisManager() // 싱글톤
    
    private let token = Bundle.main.tokenLoad(.kobis)
    
    enum ReqeustType {
        case boxOffice, detail
    }
    
    enum BoxOfficeType { case today, week }
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> BoxofficeMovie {
        var urlComponents = self.urlComponentsCreate(type: .boxOffice)
        urlComponents?.queryItems =  [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "targetDt", value: self.todayDate())
        ]
        
       return try await NetworkManager.shared.reqeustData(decodingType: BoxofficeMovie.self, url: urlComponents?.url)
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
