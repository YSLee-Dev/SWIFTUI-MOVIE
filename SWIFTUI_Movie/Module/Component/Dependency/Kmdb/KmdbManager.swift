//
//  KmdbManager.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/29/24.
//

import Foundation

struct KmdbManager: KmdbManagerProtocol {
    private init() {}
    static let shaerd = KmdbManager() // 싱글톤
    
    private let token = Bundle.main.tokenLoad(.kmdb)
    
    func moiveDetailInfoRequest(title: String, openDate: String) async throws -> KMDBMovieDetailResult?  {
        var urlComponents = URLComponents(string: "http://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp")
        urlComponents?.queryItems = [
            URLQueryItem(name: "collection", value: "kmdb_new2"),
            URLQueryItem(name: "detail", value: "Y"),
            URLQueryItem(name: "ServiceKey", value: self.token),
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "releaseDts", value: openDate)
        ]
        
        return try await NetworkManager.reqeustData(decodingType: KMDBMovieDetail.self, url: urlComponents?.url).data.first?.result.first ?? nil
    }
}
