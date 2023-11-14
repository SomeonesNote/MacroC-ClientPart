//
//  EditFollowingListView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct EditFollowingListView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @State var isEditMode: Bool = false
    @State var deleteAlert: Bool = false
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
        ScrollView(showsIndicators: false) {
            HStack {
                roundedBoxText(text: "My Artist List")
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                Spacer()
            }
            .padding(.init(top: UIScreen.getWidth(20), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(20)))
            
            if awsService.following.isEmpty {
                HStack(alignment: .center, spacing: UIScreen.getWidth(8)) {
                    Spacer()
                    Image(systemName: "face.smiling").font(.custom20semibold())
                    Text("아직 등록한 공연이 없어요 :)")
                        .font(.custom13bold())
                        .fontWidth(.expanded)
                    Spacer()
                }.shadow(color: .black.opacity(0.2),radius: UIScreen.getHeight(5))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .frame(height: UIScreen.getHeight(160))
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: UIScreen.getWidth(1))
                            .blur(radius: 2)
                            .foregroundColor(Color.white.opacity(0.1))
                            .padding(0)
                    }
                    .padding(UIScreen.getWidth(10))
            } else {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(awsService.following) { i in
                        NavigationLink {
                            ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                        } label: {
                            ProfileRectangle(image: i.artistImage, name: i.stageName)
                        }
                        .overlay(alignment: .topTrailing) {
                            if isEditMode {
                                Button {
                                    deleteAlert = true
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.custom25bold())
                                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                        .foregroundStyle(Color.appBlue)
                                        .padding(-UIScreen.getWidth(5))
                                }
                            }
                        } .scaleEffect(0.8)
                            .alert(isPresented: $deleteAlert) {
                                Alert(title: Text(""), message: Text("Do you want to unfollow?"), primaryButton: .destructive(Text("Unfollow"), action: {
                                    awsService.unFollowing(userid: awsService.user.id, artistid: i.id) {
                                        awsService.getFollowingList(completion: { })
                                    }
                                }), secondaryButton: .cancel(Text("Cancle")))
                            }
                    }
                }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
            }
            
            
        }.background(backgroundView().ignoresSafeArea()).navigationTitle("")
    }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditMode.toggle()
                    } label: {
                        toolbarButtonLabel(buttonLabel: isEditMode ? "Done" : "Edit")
                    }
                }
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

