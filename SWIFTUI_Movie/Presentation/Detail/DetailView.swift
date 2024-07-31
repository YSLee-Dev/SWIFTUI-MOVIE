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
    
    init(store: StoreOf<DetailFeature>) {
        self.store = store
        self.store.send(.viewInitialized)
    }
    
    var body: some View {
        OffsetScrollView {
            VStack(spacing: 0) {
                KFImage(self.store.state.sendedThumnailURL)
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
                             
                                if let detailData = self.store.state.detailMovieInfo {
                                    Text("\(detailData.title)")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("\(detailData.openDate)")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                              
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
    DetailView(
        store: .init(
            initialState:  .init(
                sendedMovieID: "",
                sendedThumnailURL: nil
            )
            , reducer: {DetailFeature()})
    )
}
