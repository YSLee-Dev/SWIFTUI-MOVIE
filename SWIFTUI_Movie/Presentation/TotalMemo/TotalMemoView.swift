//
//  TotalMemoView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import SwiftUI
import ComposableArchitecture

struct TotalMemoView: View {
    @State var store: StoreOf<TotalMemoFeature>
    
    var body: some View {
        Text("1")
    }
}

#Preview {
    TotalMemoView(store: .init(initialState: .init(), reducer: {TotalMemoFeature()}))
}
