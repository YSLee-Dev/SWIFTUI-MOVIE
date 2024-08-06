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
            ("네트워크 오류", "현재 네트워크 통신이 불안정합니다.")
            
        default:
            ("오류", "잠시 후 다시 시도해주세요.")
        }
    }
    
    static func getAlertModel(error: Error) -> AlertModel {
        let de = ErrorHandler.getDescription(error: error)
        return .init(title: de.title, msg: de.msg)
    }
}
