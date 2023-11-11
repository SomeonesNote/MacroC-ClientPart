//
//  ReportPage.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/11/09.
//

import SwiftUI

struct ReportPage: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @Environment(\.dismiss) var dismiss
    @State var text: String = ""
    @State var showAlert: Bool = false
    var artistID: Int
    @State var isLoading: Bool = false
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            VStack(spacing: UIScreen.getHeight(14)) {
                Spacer()
                HStack {
                    Text("Report")
                    //                    .foregroundColor(.appRed)
                        .font(.custom21black())
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .background{
                            Capsule().stroke(Color.white, lineWidth: 2)}
                        .shadow(color: .white.opacity(0.15) ,radius: 10, x: -5,y: -5)
                        .shadow(color: .black.opacity(0.35) ,radius: 10, x: 5,y: 5)
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.custom13semibold())
                            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                        Text(" ")
                            .font(.custom10semibold())
                            .foregroundColor(.gray)
                            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    }
                    VStack(alignment: .leading) {
                        Text("Please enter the reason for reporting.")
                            .font(.custom13semibold())
                            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                        Text("(more than 20character.)")
                            .font(.custom10semibold())
                            .foregroundColor(.gray)
                            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    }
                    Spacer()
                }
                
                
                TextEditor(text: $text)
                    .frame(height: UIScreen.getHeight(230), alignment: .topLeading)
                    .cornerRadius(UIScreen.getHeight(8))
                Spacer()
                
                Button {
                    isLoading = true
                    awsService.reportText = text
                    awsService.reporting(artistId: artistID) {
                        awsService.getAllArtistList {
                            awsService.getFollowingList {
                                
                                isLoading = false
                                dismiss()
                            }
                        }
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text("Report").font(.custom13bold())
                        Spacer()
                    }
                    .padding(UIScreen.getWidth(15))
                    .background(text.count < 25 ? Color.gray.opacity(0.3) : Color(appRed))
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }.disabled(text.count < 25)
            }
            if isLoading {
                ProgressView()
            }
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .background(backgroundView())
        .hideKeyboardWhenTappedAround()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Are you sure report this busking?"), message: Text("This artist will be banned from your app"), primaryButton: .destructive(Text("Report"), action: {
                awsService.reporting(artistId: artistID) {
                    showAlert = false
                }
            }), secondaryButton: .cancel(Text("Cancle")))
        }
    }
}

////MARK: -3.PREVIEW
//#Preview {
//    ReportPage()
//}
