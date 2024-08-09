//
//  SearchView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/9/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct SearchView: View {
    @State var store: StoreOf<SearchFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            LargeNavigationBar(title: "검색") {
                self.store.send(.backBtnTapped)
            }
            
            Picker(selection: self.$store.searchType, label: Text("종류 선택하기")) {
                ForEach(MovieSearchType.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 20)
            
            TextField(text: self.$store.searchQuery) {
                Text(self.store.searchType.placeHolderText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
            }
            .padding(.leading, 20)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
            }
            .padding(.bottom, 20)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(zip(self.store.searchResult.indices, self.store.searchResult)), id: \.0) { index, data in
                        HStack(alignment: .center) {
                            // 임시 포스터
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.init(uiColor: .systemGray4))
                                .frame(width: 50, height: 75)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(data.movieName)
                                    .font(.system(size: 18, weight: .bold))
                                
                                Text("\(data.openDate) | \(data.nation)")
                                    .font(.system(size: 14))
                            }
                        }
                        .frame(height: 90)
                        .onTapGesture(perform: {
                            self.store.send(.movieTapped(data.movieID))
                        })
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview {
    SearchView(store: .init(initialState: .init(), reducer: {SearchFeature()}))
}
