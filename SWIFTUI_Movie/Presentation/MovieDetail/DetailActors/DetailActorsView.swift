//
//  DetailActorsView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/2/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailActorsView: View {
    @State var store: StoreOf<DetailActorsFeature>
    @State private var titleChageRatio: CGFloat = 0
    
    var body: some View {
        NavigationScrollView(
            imageColor: .constant(.black.opacity(self.titleChageRatio)),
            imageIconBackgroundColor: .constant(.clear),
            titleColor: .constant(.black.opacity(self.titleChageRatio)),
            bgColor: .constant(.white.opacity(self.titleChageRatio)), 
            titleOffset: .constant(self.titleChageRatio),
            title: "등장인물 상세보기",
            isIgnoresTopSafeArea: true,
            backBtnTap: {
                self.store.send(.backBtnTapped)
            }) {
                LazyVStack(alignment: .leading) {
                    DetailInfoView(title: self.store.moiveTitle) {
                        ForEach(Array(zip(self.store.actorList.indices, self.store.actorList)), id: \.0.self) { index, data in
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
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
                if  -(value) > 20 && self.titleChageRatio < 1 {
                    self.titleChageRatio = (-value - 20) / 40
                } else if -(value) <= 60 && self.titleChageRatio >= 1 {
                    self.titleChageRatio = max(0,  (-value - 20) / 40)
                } else {
                    if -(value) > 20 {
                        self.titleChageRatio = 1
                    } else {
                        self.titleChageRatio = 0
                    }
                }
            })
    }
}

#Preview {
    DetailActorsView(store: .init(initialState: .init(moiveTitle: "극한직업", actorList: [KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연")]) , reducer: {DetailActorsFeature()}))
}
