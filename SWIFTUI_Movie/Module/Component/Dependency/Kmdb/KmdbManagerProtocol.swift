//
//  KmdbManagerProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/29/24.
//

import Foundation

protocol KmdbManagerProtocol {
    func moiveDetailInfoRequest(title: String, openDate: String) async throws ->  KMDBMovieDetailResult?
}
