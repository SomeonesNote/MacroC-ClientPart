//import SwiftUI
//import Alamofire
//
////struct TestUser : Codable {
////    let id : Int?
////    var username : String
////    let email : String
////    let password : String
////    let avatarUrl : String
////    let userArtist : Artist?
////    var following : [Artist]?
////}
////
////struct TestArtist : Codable {
////  var id : Int
////  var stageName : String
////  let artistInfo : String
////  let artistImage : String
////  let genres : String
////  let members : [Member]
////  let buskings : [Busking]
////  init(artist : Artist) {
////    self.id = artist.id
////    self.stageName = artist.stageName
////    self.artistInfo = artist.artistInfo
////    self.artistImage = artist.artistImage
////    self.genres = artist.genres
////    self.members = artist.members
////    self.buskings = artist.buskings
////  }
////}
////struct TestBusking: Codable {
////  let id : Int
////  let BuskingStartTime : Date
////  let BuskingEndTime : Date
////  var latitude: Double
////  var longitude: Double
////  let BuskingInfo : String
////}
//class SignUpViewModel : ObservableObject {
//  @Published var isSignUp : Bool = false
//  @Published var user : User?
//  @Published var accesseToken : String = KeychainItem.currentTokenResponse
//  @Published var allAtristList : [Artist]?
//
//
//
//    // @Published var user: TestUser = Service().getUserProfile()
//  func getUserProfile() -> User {
//      var result: User?
//    let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken)]
//    AF.request("http://localhost:3000/auth/profile", method: .post, headers: headers)
//      .validate()
//      .responseDecodable(of: User.self) { response in
//        switch response.result {
//        case .success(let userData) :
//          self.user = userData
//          self.isSignUp = true
//          print("::userdata : \(userData)")
//            result = self.user
//        case .failure(let error) :
//          print("Error : \(error)")
//        }
//      }
////      return result ?? User(id: 0, username: "", email: "", password: "", avatarUrl: "", artist: nil)
//  }
//    func getFollowingArtist(userid: Int) -> [Artist] {
//      var following : [Artist]?
//    AF.request("http://localhost:3000/user-following/\(userid)/following", method: .get)
//      .validate()
//      .responseDecodable(of: [Artist].self) { response in
//        switch response.result {
//        case .success(let followingData) :
//          following = followingData
//          print("followingData : \(followingData)")
//        case .failure(let error) :
//          print("Error \(error)")
//        }
//      }
//        return following ?? []
//  }
//  func getAllArtistList() {
//    AF.request("http://localhost:3000/artist-GET/All", method: .get)
//      .validate()
//      .responseDecodable(of: [Artist].self) { response in
//        switch response.result {
//        case .success(let allartistlist) :
//            self.allAtristList = allartistlist
//          print("artistlist \(allartistlist)")
//        case .failure(let error) :
//          print("Error : \(error)")
//        }}
//  }
//  func registerBusking() {
//  }
//}
//struct APItestView : View {
//  @StateObject private var viewModel = SignUpViewModel()
//  var body: some View {
//    VStack {
//      AsyncImage(url: URL(string: viewModel.user?.avatarUrl ?? ""))
//        .frame(width:200, height: 200)
//      Button(action : {
//
//          print(viewModel.getUserProfile())
//      }, label: {
//        Text("Push")
//      })
//      .padding()
//      Button(action : {
//        print(viewModel.getFollowingArtist(userid: 4))/*viewModel.testUser?.id ?? 0*/
//      }, label: {
//        Text("GetFollowing")
//      })
//      .padding()
//      Button(action : {
//        viewModel.getAllArtistList()
//          print( viewModel.getAllArtistList())
//      }, label: {
//        Text("AllArtistList")
//      })
//      .padding()
//    }
//  }
//}
//#Preview {
//  APItestView()
//}
