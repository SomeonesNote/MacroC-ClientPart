//
//  Component.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import Foundation
import SwiftUI

//MARK: -COLOR
let appBlue = "appBlue"
let appIndigo = "appIndigo"
let appIndigo1 = "appIndigo1"
let appSky = "appSky"

func backgroundGradient(a:Color, b: Color) -> LinearGradient {
  return LinearGradient(gradient: Gradient(colors: [a, b]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

//MARK: -IMGAE
let loginViewBG = "loginViewBG"
let loginViewBG1 = "loginViewBG1"
let loginViewBG2 = "loginViewBG2"
let loginViewBG3 = "loginViewBG3"

let topBarSteel = "topBarSteel"

let backgroundStill = Image("loginViewBG5")
let backgroundStillReverse = Image("loginViewBG4")

//MARK: -LOGO
let GoogleLogo = "GoogleLogo"
let AppleLogo = "AppleLogo"
let KakaoLogo = "KakaoLogo"
let AppLogo = "AppLogo"

let SoundCloudLogo = "SoundCloudLogo"
let YouTubeLogo = "YouTubeLogo"
let InstagramLogo = "InstagramLogo"

var gradImage = LinearGradient(
    gradient: Gradient(colors: [.white, Color(appIndigo)]),
    startPoint: UnitPoint(x: 0.2, y: 0.2),
    endPoint: .bottomTrailing
  )


//MARK: -Category
enum category: Int, CaseIterable {
    case sing
    case show
    case dance
    
    var title: String {
        switch self {
        case .sing: return "music.note"
        case .show: return "figure.dance"
        case .dance: return "figure.dance"
        }
    }
}

//MARK: -SIZE

let uiwidth = UIScreen.main.bounds.width
let uiheight = UIScreen.main.bounds.height

//MARK: -CUSTOM COMPONENT

struct customDivider: View {
    var body: some View {
        Divider()
            .frame(height: 0.4)
            .overlay(Color.white)
            .padding(.horizontal, 8)
            .opacity(0.5)
    }
}

struct backgroundView: View {
    var body: some View {
        backgroundStill
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

struct loginBackgroundView: View {
    var body: some View {
        Image(loginViewBG)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

struct roundedBoxText: View {
    var text: String
    var body: some View {
        Text(text)
            .modifier(mainpageTitleModifier())
    }
}

struct customSFButton: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .scaleEffect(1.5)
            .modifier(dropShadow())
            .foregroundColor(.white)
    }
}
    
struct sheetBoxText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .fontWeight(.heavy)
            .frame(width: 300, height: 50)
            .background{
                Capsule().stroke(Color.white, lineWidth: 2)
            }
    }
}

struct linkButton: View {
    var name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .shadow(radius: 10)
    }
}

//MARK: -EXTENSION
extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                }label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
        }
    }
}


struct toolbarButtonLabel: View {
    var buttonLabel: String
    var body: some View {
        Text(buttonLabel)
            .font(.headline)
            .fontWeight(.semibold)
            .modifier(dropShadow())
    }
}


extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}
