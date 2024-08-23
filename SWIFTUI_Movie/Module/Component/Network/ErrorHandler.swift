//
//  ErrorHandler.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/6/24.
//

import Foundation

struct ErrorHandler {
    private init() {}
    
    static func getDescription(error: Error) -> (title: String, msg: String) {
        return switch error {
        case URLError.badURL:
            ("잘못된 접근", "앱을 재실행해주세요.")
            
        case URLError.cannotDecodeContentData:
            ("데이터 오류", "현재 데이터를 로드할 수 없습니다.")
            
        case URLError.badServerResponse:
            ("서버오류", " 현재 서버가 불안정합니다.\n잠시 후 다시시도해주세요.")
            
        case URLError.notConnectedToInternet:
            ("네트워크 오류", "현재 네트워크에 연결되어 있지 않습니다.\n네트워크 연결 상태를 확인해주세요.")
            
        default:
            ("오류", "잠시 후 다시 시도해주세요.")
        }
    }
    
    static func getAlertModel(id: String, error: Error, leftBtnTitle: String, rightBtnTitle: String? = nil) -> AlertModel {
        let de = ErrorHandler.getDescription(error: error)
        return .init(id: id, title: de.title, msg: de.msg, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle)
    }
}
