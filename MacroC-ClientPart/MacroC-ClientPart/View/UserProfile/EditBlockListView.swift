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
        ZStack{
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(awsService.blockingList) { i in
                        NavigationLink {
                            ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                        } label: {
                            ProfileRectangle(image: i.artistImage, name: i.stageName)
                        }
                        .overlay(alignment: .topTrailing) {
                            if isEditMode {
                                Button {
                                    //TODO: 팔로우리스트에서 지우기
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
