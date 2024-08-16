//
//  DependencyValues.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/25/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var kobisManager: KobisManagerProtocol {
        get {self[KobisManagerKey.self]}
        set {self[KobisManagerKey.self] = newValue}
    }
    
    var kmdbManager: KmdbManagerProtocol {
        get {self[KmdbManagerKey.self]}
        set {self[KmdbManagerKey.self] = newValue}
    }
    
    var userDefaults: UserDefaultsProtocol {
        get {self[UserDefaultsKey.self]}
        set {self[UserDefaultsKey.self] = newValue}
    }
}
