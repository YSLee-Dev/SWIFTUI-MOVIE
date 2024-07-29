//
//  KmdbManagerKey.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/29/24.
//

import Foundation
import ComposableArchitecture

enum KmdbManagerKey: DependencyKey {
    static var liveValue: KmdbManagerProtocol = KmdbManager.shaerd
    static var previewValue: any KmdbManagerProtocol = KmdbManager.shaerd
}
