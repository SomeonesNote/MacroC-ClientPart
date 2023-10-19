//
//  Component.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

//MARK: -COLOR
let appBlue = "appBlue"
let appBlue2 = "appBlue2"
let appIndigo = "appIndigo"
let appIndigo1 = "appIndigo1"
let appIndigo2 = "appIndigo2"
let appSky = "appSky"
let appRed = "appRed"

func backgroundGradient(a:Color, b: Color) -> LinearGradient {
    return LinearGradient(gradient: Gradient(colors: [a, b]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

//MARK: -IMGAE
let loginViewBG = "loginViewBG"
let loginViewBG1 = "loginViewBG1"
let loginViewBG2 = "loginViewBG2"
let loginViewBG3 = "loginViewBG3"

let userBlank = "UserBlank"

let backgroundStill = Image("background")

//MARK: HAPTIC
let feedback = UINotificationFeedbackGenerator()

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
            .font(.custom20semibold())
            .modifier(dropShadow())
            .foregroundColor(.white)
    }
}

struct sheetBoxText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.custom13heavy())
            .frame(width: UIScreen.getWidth(300), height: UIScreen.getHeight(50))
            .background{
                Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(1.5))
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

//KeyboardHide
extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

//CornerRadius Corner
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

//SearchBar ClearButton
extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
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

//ToolBarButtonLabel
struct toolbarButtonLabel: View {
    var buttonLabel: String
    var body: some View {
        Text(buttonLabel)
            .font(.custom16bold())
            .modifier(dropShadow())
    }
}

//InnerShadow
extension View {
    func innerShadow<S: Shape, SS: ShapeStyle>(shape: S, color: SS, lineWidth: CGFloat = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 0, blur: CGFloat = 0, blendMode: BlendMode = .normal, opacity: Double = 1) -> some View {
        return self
            .overlay {
                // MARK: Bottom Sheet Inner Shadow
                shape
                    .stroke(color, lineWidth: 1)
                    .blendMode(blendMode)
                    .offset(x: offsetX, y: offsetY)
                    .blur(radius: blur)
                    .mask (shape)
                    .opacity(opacity)
            }
    }
}
