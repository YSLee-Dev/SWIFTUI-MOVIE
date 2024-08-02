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
            title: "등장인물 상세보기",
            isIgnoresTopSafeArea: true,
            backBtnTap: {
                
            }) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 12, height: 22)
                            .padding(.trailing, 10)
                        
                        Text("등장인물 상세보기")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(EdgeInsets(top: ViewStyle.topSafeArea + 30, leading: 20, bottom: 30, trailing: 20))
                    
                    DetailInfoView(title: self.store.moiveTitle) {
                        ForEach(self.store.actorList, id:  \.self) {
                            DetailInfoCell(imageName: "person.circle.fill", title: "\($0.name) (\( $0.englishName))", subTitle: "\($0.cast)")
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
    DetailActorsView(store: .init(initialState: .init(moiveTitle: "극한직업", actorList: [KobisMovieInfoActors(name: "마동석", englishName: "English", cast: "주연")]) , reducer: {DetailActorsFeature()}))
}
