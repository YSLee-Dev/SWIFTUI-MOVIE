//
//  UserDefaultsKey.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import Foundation
import ComposableArchitecture

enum UserDefaultsKey: DependencyKey {
    static var liveValue: UserDefaultsProtocol = UserDefaults.standard
    static var previewValue: any UserDefaultsProtocol = UserDefaults.standard
}
