//
//  DetailView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 7/30/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct DetailView: View {
    @State var store: StoreOf<DetailFeature>
    
    var body: some View {
        OffsetScrollView {
            VStack(spacing: 0) {
                KFImage(self.store.state.tappedData.url)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.init(uiColor: .systemGray4))
                    }
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width * 1.5) + 20)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .offset(y: -20)
                    .overlay {
                        VStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("\(self.store.state.tappedData.title)")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("\(self.store.state.tappedData.openDate)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                            .background {
                                LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.0), Color.gray]), startPoint: .top, endPoint: .bottom)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                        .padding(.bottom, 20)
                    }
            }
        }
        .ignoresSafeArea(.all)
        .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
            
        })
    }
}


#Preview {
    DetailView(store: .init(initialState: .init(movieID: "", tappedData:  .init(title: "범죄도시", openDate: "2024년 01월 01일", rank: "1", thumbnailURL: nil, movieID: "")), reducer: {DetailFeature()}))
}
