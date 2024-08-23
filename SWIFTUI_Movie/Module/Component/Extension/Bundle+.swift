//
//  Bundle+.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation

extension Bundle{
    enum tokenType: String {case kobis, kmdb}
    func tokenLoad(_ type: tokenType) -> String{
        guard let fileUrl = Bundle.main.url(forResource: "RequestToken", withExtension: "plist") else {return ""}
        guard let list = NSDictionary(contentsOf: fileUrl) else {return ""}
        guard let value = list[type.rawValue] as? String else {return ""}
        return value
    }
}
