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
        VStack(alignment: .leading) {
            Text("메모")
                .font(.title)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
            
            ScrollView {
            }
        }
    }
}

#Preview {
    TotalMemoView(store: .init(initialState: .init(), reducer: {TotalMemoFeature()}))
}
