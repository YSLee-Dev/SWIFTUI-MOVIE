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
        case yesterdayBoxOffice, weekBoxOffice, detail, actorSearch, actorDetail, movieSearch
    }
    
    func boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [BoxOfficeList] {
        var urlComponents = self.urlComponentsCreate(type: boxOfficeType == .week ? .weekBoxOffice : .yesterdayBoxOffice)
        urlComponents?.queryItems =  [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "targetDt", value: self.createDate(type: boxOfficeType == .week ? .weekBoxOffice : .yesterdayBoxOffice))
        ]
       let data =  try await NetworkManager.reqeustData(decodingType: BoxofficeMovie.self, url: urlComponents?.url).boxOfficeResult
        return (boxOfficeType == .week ? data.weeklyBoxOfficeList : data.dailyBoxOfficeList) ?? []
    }
    
    func detailMovieInfoRequest(moiveID: String)  async throws -> KobisMoiveDetail {
        var urlComponents = self.urlComponentsCreate(type: .detail)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "movieCd", value: moiveID)
        ]
        
        return try await NetworkManager.reqeustData(decodingType: KobisMoiveDetail.self, url: urlComponents?.url)
    }
    
    func actorListSearchRequest(actorName: String, movieName: String, requestPage: Int = 1) async throws -> [SearchActorDetail] {
        var urlComponents = self.urlComponentsCreate(type: .actorSearch)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "peopleNm", value: actorName),
            URLQueryItem(name: "filmoNames", value: movieName),
            URLQueryItem(name: "itemPerPage", value: "\(requestPage)")
        ]
        
        return try await NetworkManager.reqeustData(decodingType: SearchActor.self, url: urlComponents?.url).actorList.actorDetailList
    }
    
    func actorDetailReqeust(actorID: String) async throws -> ActorDetailInfo {
        var urlComponents = self.urlComponentsCreate(type: .actorDetail)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "peopleCd", value: actorID)
        ]
        
        return try await NetworkManager.reqeustData(decodingType: ActorDetail.self, url: urlComponents?.url).result.actorInfo
    }
    
    func movieSearchRequest(query: String, movieSearchType: MovieSearchType, requestPage: Int)  async  throws -> MovieSearch {
        var urlComponents = self.urlComponentsCreate(type: .movieSearch)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: self.token),
            URLQueryItem(name: "\(movieSearchType == .directorName ? "directorNm" : "movieNm")", value: query),
            URLQueryItem(name: "curPage", value: "\(requestPage)")
        ]
        
        return try await NetworkManager.reqeustData(decodingType: MovieSearch.self, url: urlComponents?.url)
    }
    
    private func urlComponentsCreate(type: ReqeustType) -> URLComponents? {
        let urlString = switch type {
        case .yesterdayBoxOffice: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        case .weekBoxOffice: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json"
        case .detail: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
        case .actorSearch: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/people/searchPeopleList.json"
        case .actorDetail: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/people/searchPeopleInfo.json"
        case .movieSearch: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json"
        }
        return URLComponents(string: urlString)
    }
    
    private func createDate(type: ReqeustType) -> String {
        let now = Calendar.current.date(byAdding: DateComponents(day: type == .weekBoxOffice ? -7 : -1), to: .now)!
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)
        let day = Calendar.current.component(.day, from: now)
        return "\(year)\(month < 10 ? "0" : "")\(month)\(day < 10 ? "0" : "")\(day)"
    }
}

struct KobisPreviewManager: KobisManagerProtocol {
    func detailMovieInfoRequest(moiveID: String) async throws -> KobisMoiveDetail {
        return .init(movieInfoResult: .init(moiveInfo: .init(title: "범죄도시", movieTotalMin: "120", openDate: "2024년 01월 01일", nations: [.init(name: "한국")], genres: [.init(name: "액션")], actors: [.init(name: "마동석", englishName: "MA", cast: "주인공")], companys: [.init(name: "대한영화", type: "제작사"), .init(name: "대한영화", type: "제작사")], directors: [.init(name: "봉준호")])))
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
    
    func actorListSearchRequest(actorName: String, movieName: String, requestPage: Int) async throws -> [SearchActorDetail] {
        return [
            .init(name: "마동석", id: "1", filmoList: "범죄도시1|범죄도시2"),
            .init(name: "조정석", id: "2", filmoList: "엑시트|마약왕|시간이탈자"),
            .init(name: "라미란", id: "3", filmoList: "시민덕희|정직한후보"),
            .init(name: "이정재", id: "4", filmoList: "헌트|인천상륙작전|신과함께|암살")
        ]
    }
    
    func actorDetailReqeust(actorID: String) async throws -> ActorDetailInfo {
        return .init(name: "마동석", englishName: "MA", sex: "남자", role: "주연", filmos: [
            .init(movieID: "1", movieTitle: "범죄도시1", role: "주연"),
            .init(movieID: "2", movieTitle: "범죄도시2", role: "주연")
        ])
    }
    
    func movieSearchRequest(query: String, movieSearchType: MovieSearchType, requestPage: Int)  async  throws -> MovieSearch {
        return .init(result: .init(movieDetailList: [
            MovieSearchDetail(movieID: "1", movieName: "범죄도시", openDate: "2024년 01월 01일", nation: "한국", directors: [.init(name: "봉준호"), .init(name: "마동석")]),
            MovieSearchDetail(movieID: "2", movieName: "극한직업", openDate: "2024년 02월 11일", nation: "한국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "3", movieName: "짱구는 못말려 극장판", openDate: "2024년 03월 21일", nation: "일본", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "4", movieName: "알라딘", openDate: "2024년 04월 02일", nation: "미국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "5", movieName: "7번방의 꿈", openDate: "2024년 05월 12일", nation: "미국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "6", movieName: "스파이더맨", openDate: "2024년 06월 13일", nation: "미국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "7", movieName: "스파이더맨", openDate: "2024년 06월 13일", nation: "미국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "8", movieName: "스파이더맨", openDate: "2024년 06월 13일", nation: "미국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "9", movieName: "스파이더맨", openDate: "2024년 06월 13일", nation: "미국", directors: [.init(name: "봉준호")]),
            MovieSearchDetail(movieID: "10", movieName: "스파이더맨", openDate: "2024년 06월 13일", nation: "미국", directors: [.init(name: "봉준호")])
        ], totalCount: 10))
    }
}
