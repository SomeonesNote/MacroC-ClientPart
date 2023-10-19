import SwiftUI
import Alamofire

struct TestUser : Codable {
    let id : Int?
    var username : String
    let email : String
    let password : String
    let avatarUrl : String
    let userArtist : TestArtist?
    var following : [TestArtist]?
}

struct TestArtist : Codable {
  var id : Int
  var stageName : String
  let artistInfo : String
  let artistImage : String
  let genres : String
  let members : [Member]
  let buskings : [TestBusking]
  init(testArtist : TestArtist) {
    self.id = testArtist.id
    self.stageName = testArtist.stageName
    self.artistInfo = testArtist.artistInfo
    self.artistImage = testArtist.artistImage
    self.genres = testArtist.genres
    self.members = testArtist.members
    self.buskings = testArtist.buskings
  }
}
struct TestBusking: Codable {
  let id : Int
  let BuskingStartTime : Date
  let BuskingEndTime : Date
  var latitude: Double
  var longitude: Double
  let BuskingInfo : String
}
class SignUpViewModel : ObservableObject {
  @Published var isSignUp : Bool = false
  @Published var testUser : TestUser?
  @Published var accesseToken : String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFzZGZhc2QiLCJpYXQiOjE2OTc2MTkwNDIsImV4cCI6MTY5NzYyMjY0Mn0.Uet26jTQ00Cly0vrZoZZLwK10G-Bt0CjQPeeQuT6D3s"
//  KeychainItem.currentUserIdentifier
  @Published var allAtristList : [TestArtist]?
    
    
    
    // @Published var user: TestUser = Service().getUserProfile()
  func getUserProfile() -> TestUser {
      var result: TestUser?
    let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken)]
    AF.request("http://localhost:3000/auth/profile", method: .post, headers: headers)
      .validate()
      .responseDecodable(of: TestUser.self) { response in
        switch response.result {
        case .success(let userData) :
          self.testUser = userData
          self.isSignUp = true
          print("userdata : \(userData)")
            result = self.testUser
        case .failure(let error) :
          print("Error : \(error)")
        }
      }
      return result ?? TestUser(id: 0, username: "", email: "", password: "", avatarUrl: "", userArtist: nil, following: [])
  }
  func getFollowingArtist(userid: Int) {
    AF.request("http://localhost:3000/user-following/\(userid)/following", method: .get)
      .validate()
      .responseDecodable(of: [TestArtist].self) { response in
        switch response.result {
        case .success(let followingData) :
          self.testUser?.following = followingData
          print("followingData : \(followingData)")
        case .failure(let error) :
          print("Error \(error)")
        }
      }
  }
  func getAllArtistList() {
    AF.request("http://localhost:3000/artist-GET/All", method: .get)
      .validate()
      .responseDecodable(of: [TestArtist].self) { response in
        switch response.result {
        case .success(let allartistlist) :
            self.allAtristList = allartistlist
          print("artistlist \(allartistlist)")
        case .failure(let error) :
          print("Error : \(error)")
        }}
  }
  func registerBusking() {
  }
}
struct APItestView : View {
  @StateObject private var viewModel = SignUpViewModel()
  var body: some View {
    VStack {
      AsyncImage(url: URL(string: viewModel.testUser?.avatarUrl ?? ""))
        .frame(width:200, height: 200)
      Button(action : {
        viewModel.getUserProfile()
      }, label: {
        Text("Push")
      })
      .padding()
      Button(action : {
        viewModel.getFollowingArtist(userid: 4)/*viewModel.testUser?.id ?? 0*/
      }, label: {
        Text("GetFollowing")
      })
      .padding()
      Button(action : {
        viewModel.getAllArtistList()
      }, label: {
        Text("AllArtistList")
      })
      .padding()
    }
  }
}
#Preview {
  APItestView()
}
