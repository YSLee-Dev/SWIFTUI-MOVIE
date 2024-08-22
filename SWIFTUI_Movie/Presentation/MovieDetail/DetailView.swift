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
    @Namespace private var memoView
    private let posterWidth = UIScreen.main.bounds.width
    
    init(store: StoreOf<DetailFeature>) {
        self.store = store
        self.store.send(.viewInitialized)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
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
                    LazyVStack(alignment: .leading, spacing: 0) {
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
                                                .onAppear {
                                                    if self.store.scrollToMemoRequested && self.store.detailMovieInfo != nil {
                                                        withAnimation {
                                                            proxy.scrollTo(self.memoView)
                                                        }
                                                        self.store.send(.scrollToMemoSuccss)
                                                    }
                                                }
                                        } else {
                                            HStack {
                                                Spacer()
                                                VStack(spacing: 20) {
                                                    ProgressView()
                                                        .tint(.white)
                                                        .scaleEffect(1.5)
                                                    
                                                    Text("영화를 가져오고 있어요.")
                                                        .font(.system(size: 20, weight: .bold))
                                                        .foregroundColor(.white)
                                                }
                                                Spacer()
                                            }
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
                                    HStack(alignment: .top) {
                                        if self.store.isCompanyViewExpansion {
                                            VStack(alignment: .leading, spacing: 20) {
                                                ForEach(companys, id: \.self) { data in
                                                    DetailInfoCell(imageName: "building.2.crop.circle.fill", title: data.name)
                                                }
                                            }
                                        } else {
                                            DetailInfoCell(imageName: "building.2.crop.circle.fill", title: "\(firstCompanys.name)")
                                        }
                                        if companys.count >= 2 {
                                            Button(action: {
                                                self.store.send(.companysMoreViewBtnTapped)
                                            }, label: {
                                                Image(systemName: self.store.isCompanyViewExpansion ? "chevron.up" : "chevron.down")
                                                    .resizable()
                                                    .frame(width: 17, height: 10)
                                                    .foregroundColor(.black)
                                            })
                                            .padding(.top, 15)
                                        }
                                        Spacer()
                                    }
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
                                        HStack {
                                            Text("더보기")
                                            Spacer()
                                        }
                                    }
                                    .foregroundColor(.gray)
                                }
                            }
                            
                            DetailInfoView(title: "영화메모") {
                                Button {
                                    self.store.send(.memoBtnTapped)
                                } label: {
                                    let title = self.store.movieMemo == nil ? "버튼을 눌러 메모를 입력해보세요!" : self.store.movieMemo!.movieNote.isEmpty ? "메모에 저장된 텍스트가 없어요." : self.store.movieMemo!.movieNote
                                    
                                    HStack {
                                        Text(title)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                            .id(self.memoView)
                        }
                    }
                }
                .overlay {
                    if let store =  self.store.scope(state: \.popupState, action: \.popupAction) {
                        PopupView(store: store)
                    }
                }
        }
        .sheet(item: self.$store.scope(state: \.memoViewState, action: \.memoViewAction)) { store in
            MovieDetailMemoView(store: store)
        }
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
