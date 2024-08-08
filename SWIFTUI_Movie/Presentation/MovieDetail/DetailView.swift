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
        NavigationScrollView(
            imageColor: .constant(.black),
            imageIconBackgroundColor: .init(get: {Color.white.opacity(1 - self.posterStytleRatio)}, set: {_ in}),
            titleColor: .init(get: {.black.opacity(self.posterStytleRatio)}, set: { _ in}),
            bgColor: .init(get: {Color.white.opacity(self.posterStytleRatio)}, set: {_ in}),
            titleOffset: .constant(self.posterStytleRatio),
            title: self.store.state.detailMovieInfo?.title ?? "",
            isIgnoresTopSafeArea: true,
            isLargeNavigationBarShow: false,
            backBtnTap: {
                self.store.send(.backBtnTapped)
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    KFImage(self.store.state.thumnailURL)
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
                    
                    if let detailData = self.store.state.detailMovieInfo {
                        DetailInfoView(title: "영화정보") {
                            DetailInfoCell(imageName: "calendar.circle.fill", title: detailData.openDate)
                            
                            DetailInfoCell(imageName: "clock.circle.fill", title: "\(detailData.movieTotalMin)분")
                            
                            DetailInfoCell(imageName: "book.closed.circle.fill", title: detailData.genres.enumerated().reduce(""){ s1, s2 in
                                "\(s1)" + "\(s2.element.name)\(s2.offset == detailData.genres.count - 1 ? "" : ", ")"
                            })
                        }
                        
                        DetailInfoView(title: "제작정보") {
                            if let firstNation = detailData.nations.first {
                                DetailInfoCell(imageName: "flag.circle.fill", title: "\(firstNation.name)\(detailData.nations.count >= 2 ? " 등" : "")")
                            }
                            
                            if let firstDirector = detailData.directors.first {
                                DetailInfoCell(imageName: "pencil.circle.fill", title: "\(firstDirector.name)\(detailData.directors.count >= 2 ? " 등" : "")")
                            }
                            
                            
                            let companys = detailData.companys.filter {$0.type == "제작사"}
                            if let firstCompanys = companys.first {
                                DetailInfoCell(imageName: "building.2.crop.circle.fill", title: "\(firstCompanys.name)\(companys.count >= 2 ? " 등" : "")")
                            }
                        }
                        
                        DetailInfoView(title: "등장인물") {
                            let actorList = detailData.actors.count <= 5 ? detailData.actors : Array(detailData.actors[0 ... 4])
                            ForEach(Array(zip(actorList.indices, actorList)), id: \.0.self) { index, data in
                                DetailInfoCell(imageName: "person.circle.fill", title: "\(data.totalName)", subTitle: "\(data.cast)") {
                                    if self.store.state.actorInfoLoading != index { return nil }
                                    return  AnyView(
                                        ProgressView()
                                    )
                                }
                                .onTapGesture {
                                    self.store.send(.actorTapped(index))
                                }
                            }
                            
                            if detailData.actors.count > 5 {
                                Button(action: {
                                    self.store.send(.actorsMoreBtnTapped(detailData))
                                }) {
                                    Text("더보기")
                                }
                                .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .alert(self.$store.scope(state: \.alertState, action: \.alertAction))
            .onPreferenceChange(ScrollOffsetKey.self, perform: { offset in
                if !self.firstValueCheck {
                    self.firstValueCheck = true
                    return
                }
                
                let checkOffset = -offset / ((self.posterWidth * 1.5) - 120)
                if  checkOffset >= 0.8 && checkOffset <= 1.05 {
                    let value = (-offset - ((self.posterWidth * 1.5) - 120) * 0.8) / 100
                    self.posterStytleRatio = value >= 1 ? 1 : (value < 0.1 ? 0 : value)
                } else if checkOffset > 0.81 {
                    if -(offset) > 20 {
                        self.posterStytleRatio = 1
                    } else {
                        self.posterStytleRatio = 0
                    }
                } else if posterStytleRatio >= 0.1 && checkOffset <= 0.8 {
                    self.posterStytleRatio = 0
                }
            })
    }
}


#Preview {
    DetailView(
        store: .init(
            initialState:  .init(
                sendedMovieID: "",
                thumnailURL: nil
            )
            , reducer: {DetailFeature()})
    )
}
