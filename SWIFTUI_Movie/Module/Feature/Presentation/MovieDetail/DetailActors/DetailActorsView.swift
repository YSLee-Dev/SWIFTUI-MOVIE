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
    
    var body: some View {
        StandardNavigationScrollView(
            title: "등장인물 상세보기",
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
    }
}

#Preview {
    DetailActorsView(store: .init(initialState: .init(moiveTitle: "극한직업", actorList: [KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연"), KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연")]) , reducer: {DetailActorsFeature()}))
}
