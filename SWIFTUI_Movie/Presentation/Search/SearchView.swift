//
//  SearchView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/9/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    @State var store: StoreOf<SearchFeature>
    
    var body: some View {
        Text("")
    }
}

#Preview {
    SearchView(store: .init(initialState: .init(), reducer: {SearchFeature()}))
}
