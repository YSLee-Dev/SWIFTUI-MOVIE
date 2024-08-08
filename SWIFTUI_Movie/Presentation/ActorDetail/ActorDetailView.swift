//
//  ActorDetailView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/4/24.
//

import SwiftUI
import ComposableArchitecture

struct ActorDetailView: View {
    @State private var store: StoreOf<ActorDetailFeature>
    @State private var titleChageRatio: CGFloat = 0
    
    init(store: StoreOf<ActorDetailFeature>) {
        self.store = store
        self.store.send(.viewInitialized)
    }
    
    var body: some View {
        NavigationScrollView(
            imageColor: .constant(.black.opacity(self.titleChageRatio)),
            imageIconBackgroundColor: .constant(.clear),
            titleColor: .constant(.black.opacity(self.titleChageRatio)),
            bgColor: .constant(.white.opacity(self.titleChageRatio)), 
            titleOffset: .constant(self.titleChageRatio),
            title: "\(self.store.actorDetailInfo?.name ?? "")",
            isIgnoresTopSafeArea: true,
            backBtnTap: {
                self.store.send(.backBtnTapped)
            }) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName:  "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        
                        VStack(alignment: .leading, spacing: 5) {
                            if let info = self.store.actorDetailInfo {
                                Text(info.totalName)
                                    .font(.title2)
                                    .bold()
                                Text(info.sex)
                                Text(info.role)
                            } else {
                                Text("정보를 가져오는 중")
                                    .font(.title2)
                                    .bold()
                                ProgressView()
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    DetailInfoView(title: "주요작품") {
                        ForEach(Array(zip(self.store.filmoList.indices, self.store.filmoList)), id:  \.0) { index, data in
                            DetailInfoCell(imageName: "popcorn.circle.fill", imageURL: data.url, title: "\(data.movieTitle)", subTitle: "\(data.role)")
                                .onTapGesture(perform: {
                                    self.store.send(.movieTapped(data.movieID))
                                })
                        }
                    }
                }
            }
            .alert(self.$store.scope(state: \.alertState, action: \.alertAction))
            .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
                if  -(value) > 20 && self.titleChageRatio != 1 {
                    self.titleChageRatio = (-value - 20) / 40
                } else if -(value) <= 40 && self.titleChageRatio != 0 {
                    self.titleChageRatio = max(0,  (-value - 20) / 60)
                }
            })
    }
}

#Preview {
    ActorDetailView(
        store: .init(initialState: .init(actorID: "123"), reducer: {ActorDetailFeature()})
    )
}
