//
//  TotalMemoView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/19/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct TotalMemoView: View {
    @State var store: StoreOf<TotalMemoFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("메모")
                .font(.title)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
            
            ScrollView {
                LazyVStack(alignment: .center,  spacing: 20) {
                    if self.store.nowMemoList.isEmpty {
                        HStack {
                            Spacer()
                            Text("저장된 메모가 없어요.\n영화 상세페이지에서 메모를 등록할 수 있어요.")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.top, 20)
                    } else {
                        ForEach(Array(zip(self.store.nowMemoList.indices, self.store.nowMemoList)), id: \.0) { index, data in
                            HStack {
                                KFImage(data.thumnail)
                                    .resizable()
                                    .placeholder {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.1))
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: 100, height: 150)
                                    .padding(.trailing, 10)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(data.movieTitle)
                                        .font(.system(size: 22, weight: .heavy))
                                    
                                    Text(data.movieNote)
                                        .font(.callout)
                                        .lineLimit(3)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.forward")
                                    .padding(.trailing, 10)
                            }
                            .padding(10)
                            .background {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                self.store.send(.memoTapped(index))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.store.send(.viewShowed)
        }
    }
}

#Preview {
    TotalMemoView(store: .init(initialState: .init(), reducer: {TotalMemoFeature()}))
}
