//
// EditBlockListView.swift
// MacroC-ClientPart
//
// Created by Kimdohyun on 11/9/23.
//

import SwiftUI

struct EditBlockListView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @Environment(\.dismiss) var dismiss
    @State var isEditMode: Bool = false
    @State var deleteAlert: Bool = false
    @State var isLoading: Bool = false
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    roundedBoxText(text: "Blocked Artist List")
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    Spacer()
                }
                .padding(.init(top: UIScreen.getWidth(20), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(20)))
                
                if awsService.blockingList.isEmpty {
                    HStack(alignment: .center, spacing: UIScreen.getWidth(8)) {
                        Spacer()
                        Image(systemName: "face.smiling").font(.custom20semibold())
                        Text("차단한 아티스트가 없어요 :)")
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
                        ForEach(awsService.blockingList) { i in
                            NavigationLink {
                                BlockedArtistView(viewModel: BlockedArtistViewModel(artist: i))
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
                                    Alert(title: Text(""), message: Text("Do you want to unBlock?"), primaryButton: .destructive(Text("UnBlock"), action: {
                                        //TODO: 팔로우 리스트에서 삭제
                                        isLoading = true
                                        awsService.unblockingArtist(artistId: i.id) { // 언팔하는 함수
                                            awsService.getBlockArtist{
                                                isLoading = false
                                                dismiss()
                                            }
                                        }
                                    }), secondaryButton: .cancel(Text("Cancle")))
                                }
                        }
                    }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
                }
               
            }.blur(radius: isLoading ? 15 : 0)
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay(alignment: .center) {
                        ProgressView()
                    }
            }
        }
        .background(backgroundView().ignoresSafeArea()).navigationTitle("")
        .onAppear {
            isLoading = true
            awsService.getBlockArtist{
                isLoading = false
            }
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
        EditBlockListView()
    }
}
//MARK: -4.EXTENSION
