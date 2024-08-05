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
            title: "\(self.store.actorDetailInfo?.name ?? "")",
            isIgnoresTopSafeArea: true,
         backBtnTap: {
             self.store.send(.backBtnTapped)
         }) {
             VStack(alignment: .leading) {
                 HStack(alignment: .center) {
                     Image(systemName: "chevron.backward")
                         .resizable()
                         .foregroundColor(.black)
                         .frame(width: 12, height: 22)
                         .padding(.trailing, 10)
                         .onTapGesture {
                             self.store.send(.backBtnTapped)
                         }
                     
                     Text("\(self.store.actorDetailInfo?.name ?? "")")
                         .font(.title)
                         .fontWeight(.bold)
                     
                     Spacer()
                 }
                 .padding(EdgeInsets(top: ViewStyle.topSafeArea + 30, leading: 20, bottom: 30, trailing: 20))
                 
                 if let info = self.store.actorDetailInfo {
                     HStack(alignment: .center, spacing: 20) {
                         Image(systemName:  "person.circle.fill")
                             .resizable()
                             .frame(width: 100, height: 100)
                             .foregroundColor(.gray)
                         
                         VStack(alignment: .leading, spacing: 5) {
                             Text(info.totalName)
                                 .font(.title2)
                                 .bold()
                             Text(info.sex)
                             Text(info.role)
                         }
                     }
                     .padding(.horizontal, 20)
                     
                     DetailInfoView(title: "주요작품") {
                         ForEach(info.filmos, id:  \.self) {
                             DetailInfoCell(imageName: "popcorn.circle.fill", title: "\($0.movieTitle)", subTitle: "\($0.role)")
                         }
                     }
                 }
             }
        }
         .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
             if  -(value) > 20 && self.titleChageRatio != 1 {
                 self.titleChageRatio = (-value - 20) / 40
             } else if -(value) >= 60 && self.titleChageRatio != 0 {
                 self.titleChageRatio = 0
             } else if self.titleChageRatio != 0  {
                 self.titleChageRatio = 0
             }
         })
    }
}

#Preview {
    ActorDetailView(
        store: .init(initialState: .init(actorID: "123"), reducer: {ActorDetailFeature()})
    )
}
