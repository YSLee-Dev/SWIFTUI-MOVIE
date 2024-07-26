//
//  KobisManagerKey.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/26/24.
//

import Foundation
import ComposableArchitecture

enum KobisManagerKey: DependencyKey {
    static var liveValue: KobisManagerProtocol = KobisManager.shaerd
    static var previewValue: any KobisManagerProtocol = KobisPreviewManager()
}
