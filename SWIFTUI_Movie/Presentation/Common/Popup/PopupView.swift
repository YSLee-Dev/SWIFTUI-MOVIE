//
//  PopupView.swift
//  SWIFTUI_Movie
//
//  Created by 이윤수 on 8/22/24.
//

import SwiftUI
import ComposableArchitecture

struct PopupView: View {
    private let deviceSize = UIScreen.main.bounds.size
    @State private var store: StoreOf<PopupFeature>
    @State private var isShow = false
    
    init(store: StoreOf<PopupFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 15) {
            Text(self.store.title)
                .font(.title)
                .bold()
            
            Divider()
            
            Text(self.store.msg)
                .font(.system(size: 20))
                .padding(.bottom, 20)
            
                HStack {
                    Button(action: {
                        self.store.send(.leftBtnTapped)
                    }) {
                        Text(self.store.leftBtnTitle)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background {
                                Color(uiColor: .secondarySystemBackground)
                                    .cornerRadius(15)
                            }
                    }
                    if let right = self.store.rightBtntTitle {
                        Button(action: {
                            self.store.send(.rightBtnTapped)
                        }) {
                            Text(right)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background {
                                    Color(uiColor: .secondarySystemBackground)
                                        .cornerRadius(15)
                                }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(20)
            .offset(y: self.isShow ? 0 : 100)
            .animation(.spring(duration: 0.4, bounce: 0.35), value: self.isShow)
        }
        .onAppear {
            self.isShow = true
        }
        .background(Color.black.opacity(0.3))
    }
}

#Preview {
    PopupView(store: .init(initialState: .init(title: "알림", msg: "현재 오류 발생", leftBtnTitle: "취소", rightBtntTitle: "확인"), reducer: {PopupFeature()}))
}
