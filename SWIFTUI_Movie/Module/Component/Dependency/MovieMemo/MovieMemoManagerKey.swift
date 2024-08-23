//
//  MovieMemoManagerKey.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import Foundation
import ComposableArchitecture

enum MovieMemoManagerKey: DependencyKey {
    static var liveValue: MovieMemoManagerProtocol = MovieMemoManager.shared
    static var previewValue: any MovieMemoManagerProtocol = MovieMemoPreviewManager.shared
}
