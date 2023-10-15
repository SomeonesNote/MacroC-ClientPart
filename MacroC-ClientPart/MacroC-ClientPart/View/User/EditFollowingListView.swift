//
//  EditFollowingListView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditFollowingListView: View {
    
    //MARK: -1.PROPERTY
    @State var isEditMode: Bool = false
    @State var deleteAlert: Bool = false
    var followingtList = dummyUserFollowing
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(followingtList) { i in
                    NavigationLink {
                        ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                    } label: {
                        ProfileRectangle(image: i.artistimage, name: i.stagename)
                        
                    }
                    .overlay(alignment: .topTrailing) {
                        if isEditMode {
                            Button {
                                //TODO: 팔로우리스트에서 지우기
                                deleteAlert = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.custom28bold())
                                    .shadow(color: .black.opacity(0.7),radius: 5)
                                    .foregroundStyle(Color.appBlue)
                                    .padding(-5)
                            }
                        }
                    } .scaleEffect(0.8)
                }
            }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
        }.background(backgroundView().ignoresSafeArea()).navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditMode.toggle()
                    } label: {
                        toolbarButtonLabel(buttonLabel: isEditMode ? "완료" : "수정")
                    }
                }
            }
//            .alert("ddd", isPresented: $deleteAlert) {
//                Text("ddfad")
//            }
            .alert(isPresented: $deleteAlert) {
                Alert(title: Text(""), message: Text("Do you want to unfollow?"), primaryButton: .destructive(Text("Unfollow"), action: {
                    //TODO: 팔로우 리스트에서 삭제
                }), secondaryButton: .cancel(Text("Cancle")))
            }
            .toolbarBackground(.hidden, for: .navigationBar)
    }
}

//MARK: -3.PREVIEW

#Preview {
    NavigationView {
        EditFollowingListView()
    }
}

//MARK: -4.EXTENSION

