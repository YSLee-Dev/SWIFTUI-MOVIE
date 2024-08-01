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
            VStack(alignment: .leading, spacing: 0) {
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
                
                VStack(alignment: .leading) {
                    if let detailData = self.store.state.detailMovieInfo {
                        Text("영화 정보")
                            .font(.title2)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 20)  {
                            DetailInfoView(imageName: "calendar.circle.fill", title: detailData.openDate)
                            
                            DetailInfoView(imageName: "clock.circle.fill", title: "\(detailData.movieTotalMin)분")
                            
                            let companys = detailData.companys.filter {$0.type == "제작사"}
                            if let firstCompanys = companys.first {
                                DetailInfoView(imageName: "building.2.crop.circle.fill", title: "\(firstCompanys.name)\(companys.count >= 2 ? " 등" : "")")
                            }
                            
                            DetailInfoView(imageName: "book.closed.circle.fill", title: detailData.genres.enumerated().reduce(""){ s1, s2 in
                                "\(s1)" + "\(s2.element.name)\(s2.offset == detailData.genres.count - 1 ? "" : ", ")"
                            })
                            
                            if let firstNation = detailData.nations.first {
                                DetailInfoView(imageName: "flag.circle.fill", title: "\(firstNation.name)\(detailData.nations.count >= 2 ? " 등" : "")")
                            }
                        }
                        .padding(20)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.1))
                        }
                    }
                }
                .padding(.horizontal, 20)
                
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
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 10, height: 17)
                            .background {
                                Circle()
                                    .fill(Color.white.opacity(1 - self.posterStytleRatio))
                                    .frame(width: 30, height: 30)
                                    .offset(x: 2)
                            }
                    }
                    
                    Spacer()
                    
                    if let detailData = self.store.state.detailMovieInfo {
                        Text(detailData.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.black.opacity(self.posterStytleRatio))
                            .padding(.trailing, 10)
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background {
                    Color.white.opacity(self.posterStytleRatio)
                        .ignoresSafeArea()
                }
                Spacer()
            }
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
