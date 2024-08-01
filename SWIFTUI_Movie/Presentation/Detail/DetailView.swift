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
    @State private var store: StoreOf<DetailFeature>
    @State private var posterStytleRatio: CGFloat = 0
    @State private var firstValueCheck = false
    private let posterWidth = UIScreen.main.bounds.width
    
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
                    .frame(width: self.posterWidth, height: (self.posterWidth * 1.5) + 20)
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
                            .frame(width: self.posterWidth, height: 125)
                            .background {
                                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.gray]), startPoint: .top, endPoint: .bottom)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                        .padding(.bottom, 20)
                    }
                
                Text("123")
                    .font(.system(size: 30, weight: .bold))
                    .frame(height: 1000)
            }
        }
        .ignoresSafeArea(.all)
        .overlay {
            VStack {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .foregroundColor(
                                .init(hue: 136, saturation: 0, brightness: self.posterStytleRatio)
                            )
                            .frame(width: 30, height: 30)
                            .background {
                                Color.init(hue: 0, saturation: 0, brightness:  1 - self.posterStytleRatio)
                                    .clipShape(Circle())
                            }
                    }
                    
                    Spacer()
                    
                    if let detailData = self.store.state.detailMovieInfo {
                        Text(detailData.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black.opacity(self.posterStytleRatio))
                            .padding(.trailing, 30)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .padding(.top, 10)
        }
        .onPreferenceChange(ScrollOffsetKey.self, perform: { offset in
            if !self.firstValueCheck {
                self.firstValueCheck = true
                return
            }
            
            let checkOffset = -offset / ((self.posterWidth * 1.5) - 120)
            if  checkOffset >= 0.8 && checkOffset <= 1.05 {
                let value = (-offset - ((self.posterWidth * 1.5) - 120) * 0.8) / 100
                self.posterStytleRatio = value < 0.1 ? 0 : value
            } else if checkOffset < 0.7, self.posterStytleRatio != 0 {
                self.posterStytleRatio = 0
            } else if checkOffset > 1.05, self.posterStytleRatio != 1 {
                self.posterStytleRatio = 1
            }
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
