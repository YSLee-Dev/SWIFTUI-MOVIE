//
//  MovieDetailMemoView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/16/24.
//

import SwiftUI
import ComposableArchitecture

struct MovieDetailMemoView: View {
    @State private var store: StoreOf<MovieDetailMemoFeature>
    @FocusState private var isFocus: Bool?
    
    init(store: StoreOf<MovieDetailMemoFeature>) {
        self.store = store
    }
    
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
            
            ScrollView {
                DetailInfoView(title: "메모") {
                    TextEditor(text: self.$store.insertedValue)
                        .focused(self.$isFocus, equals: true)
                        .scrollContentBackground(.hidden)
                        .frame(height: UIScreen.main.bounds.height / 2)
                }
                Button {
                    self.store.send(.returnKeyPressed)
                } label: {
                    Text("저장")
                        .tint(.black)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.isFocus = true
            }
        }
    }
}

#Preview {
    MovieDetailMemoView(store: .init(initialState: .init(movieDetailNoteData: MovieDetailMemo(movieID: "123", movieTitle: "영화제목", movieNote: "안녕하세요", thumnail: nil)), reducer: {MovieDetailMemoFeature()}))
}
