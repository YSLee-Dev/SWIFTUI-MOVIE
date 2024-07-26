//
//  KobisManagerProtocol.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/26/24.
//

import Foundation

enum BoxOfficeType { case today, week }

protocol KobisManagerProtocol {
    func  boxOfficeListRequest(boxOfficeType: BoxOfficeType) async throws -> [DailyBoxOfficeList]
}
