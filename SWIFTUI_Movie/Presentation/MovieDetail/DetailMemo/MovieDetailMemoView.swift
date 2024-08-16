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
        VStack {
            LargeNavigationBar(
                title: self.store.movieDetailNoteData.movieTitle,
                backBtnImageName: "chevron.down",
                backBtnSize: .init(width: 20, height: 12),
                backBtnTap: {
                    self.store.send(.backBtnTapped)
                })
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 15, trailing: 20))
            
            DetailInfoView(title: "메모") {
                TextEditor(text: self.$store.insertedValue)
                    .scrollContentBackground(.hidden)
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .onKeyPress(.return) {
                        self.store.send(.returnKeyPressed)
                        return .handled
                    }
            }
            
            Spacer()
        }
    }
}

#Preview {
    MovieDetailMemoView(store: .init(initialState: .init(movieDetailNoteData: MovieDetailMemo(movieID: "123", movieTitle: "영화제목", movieNote: "안녕하세요", thumnail: nil)), reducer: {MovieDetailMemoFeature()}))
}
