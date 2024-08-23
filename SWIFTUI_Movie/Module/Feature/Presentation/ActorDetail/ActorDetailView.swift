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
    
    init(store: StoreOf<ActorDetailFeature>) {
        self.store = store
    }
    
    var body: some View {
        StandardNavigationScrollView(
            title: "\(self.store.actorDetailInfo?.name ?? "")",
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
            .onAppear {
                self.store.send(.viewInitialized)
            }
            .overlay {
                if let store =  self.store.scope(state: \.popupState, action: \.popupAction) {
                    PopupView(store: store)
                }
            }
    }
}

#Preview {
    ActorDetailView(
        store: .init(initialState: .init(actorID: "123"), reducer: {ActorDetailFeature()})
    )
}
