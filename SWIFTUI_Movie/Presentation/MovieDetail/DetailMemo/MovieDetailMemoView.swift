//
//  MovieDetailMemoView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import SwiftUI
import ComposableArchitecture

struct MovieDetailMemoView: View {
    @State var store: StoreOf<MovieDetailMemoFeature>
    
    var body: some View {
        Text("123")
    }
}

#Preview {
    MovieDetailMemoView(store: .init(initialState: .init(), reducer: {MovieDetailMemoFeature()}))
}
