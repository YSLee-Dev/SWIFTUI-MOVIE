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
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
            
            Picker(selection: self.$store.searchType, label: Text("종류 선택하기")) {
                ForEach(MovieSearchType.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            
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
            .padding(.horizontal, 20)
            
            ScrollView {
                if self.store.nowSearching && !self.store.searchQuery.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView() {
                            Text("영화를 가져오고 있어요.")
                        }
                        Spacer()
                    }
                    
                } else {
                    LazyVStack(alignment: .leading) {
                        if self.store.searchResult.isEmpty && !self.store.nowSearching && !self.store.searchQuery.isEmpty {
                            Text("검색된 영화가 없어요.")
                                .font(.title3)
                            
                        } else {
                            ForEach(Array(zip(self.store.searchResult.indices, self.store.searchResult)), id: \.0) { index, data in
                                LazyHStack(alignment: .center) {
                                    // 임시 포스터
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.init(uiColor: .systemGray4))
                                        .frame(width: 50, height: 75)
                                        .padding(.trailing, 10)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(data.movieName)
                                            .font(.system(size: 18, weight: .bold))
                                            .lineLimit(1)
                                        
                                        if let firstDirectors = data.directors.first {
                                            Text("\(firstDirectors.name) \(data.directors.count >= 2 ? "등" : "")  |  \(data.nation)")
                                                .font(.system(size: 14))
                                                .lineLimit(1)
                                        }
                                        
                                        if !data.openDate.isEmpty {
                                            Text("\(data.openDate)\(data.directors.isEmpty ? " | \(data.nation)" : "")")
                                                .font(.system(size: 14))
                                                .lineLimit(1)
                                        } else if data.openDate.isEmpty && data.directors.isEmpty {
                                            Text(data.nation)
                                                .font(.system(size: 14))
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .onAppear {
                                    if index % 10 == 9 && self.store.nowPage < ((index + 1) / 10) + 1 {
                                        self.store.send(.morePageLoadingRequest)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .frame(height: 90)
                                .onTapGesture(perform: {
                                    self.store.send(.movieTapped(data.movieID))
                                })
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    SearchView(store: .init(initialState: .init(), reducer: {SearchFeature()}))
}
