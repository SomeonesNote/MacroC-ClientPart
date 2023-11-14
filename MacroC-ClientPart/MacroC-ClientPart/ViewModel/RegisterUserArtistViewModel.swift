//
//  RegisterUserArtistViewModel.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/27.
//

import SwiftUI
import PhotosUI
import Alamofire

class RegisterUserArtistViewModel: ObservableObject {
    
    @Published var isEditMode: Bool = true
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var popImagePicker: Bool = false
    @Published var copppedImageData: Data?
    @Published var croppedImage: UIImage? 
    @Published var isLoading: Bool = false

    
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    
    @Published var artistName: String = ""
    @Published var artistInfo : String = ""
    @Published var genres: String = ""
    
    @Published var youtubeURL: String = ""
    @Published var instagramURL: String = ""
    @Published var soundcloudURL: String = ""
    
    
    
//    let serverURL: String = "http://localhost:3000"
    let serverURL: String = "https://macro-app.fly.dev"
    
//    func postUserArtist(completion: @escaping () -> Void) {
//        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
//        let parameters: [String: String] = [
//            "stageName" : artistName ,
//            "genres" : genres ,
//            "artistInfo" : artistInfo ,
//            "youtubeURL" : youtubeURL ,
//            "instagramURL" : instagramURL ,
//            "soundcloudURL" : soundcloudURL
//        ]
//        
//        if !artistName.isEmpty  && !artistInfo.isEmpty {
//            AF.upload(multipartFormData: { multipartFormData in
//                if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
//                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
//                }
//                else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
//                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
//                }
//                for (key, value) in parameters {
//                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
//                }
//            }, to: "\(serverURL)/artist-POST/create", method: .post, headers: headers)
//            .response { response in
//                switch response.result {
//                case .success:
//                   print("postUserArtist.success")
//                case .failure(let error):
//                    print("postUserArtist.error : \(error.localizedDescription)")
//                }
//            }
//            completion()
//        }
//    }
    
    
    }
