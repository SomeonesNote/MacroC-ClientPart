//
//  Font.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import SwiftUI

extension Font {
    
    //Light
    static func custom24light() -> Font {
        return Font.custom("Pretendard-Light", size: 24)
    }
    
    //Regular
    static func custom14regular() -> Font {
        return Font.custom("Pretendard-Regulard", size: 14)
    }
    
    static func custom16regular() -> Font {
        return Font.custom("Pretendard-Regular", size: 16)
    }
    
    static func custom24regular() -> Font {
        return Font.custom("Pretendard-Regulard", size: 24)
    }
    
    static func custom40regular() -> Font {
        return Font.custom("Pretendard-Regulard", size: 40)
    }
    
    //SemiBold
    static func custom10semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 10)
    }
    
    static func custom12semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 12)
    }
    
    static func custom16semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 16)
    }
    
    static func custom17semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 17)
    }
    
    static func custom24semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 24)
    }
    
    //Bold
    static func custom10bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 10)
    }
    
    static func custom12bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 12)
    }
    
    static func custom14bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 14)
    }
    
    static func custom16bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 16)
    }
    
    static func custom17bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 17)
    }
    
    static func custom18bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 18)
    }
    
    static func custom20bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 20)
    }
    
    static func custom22bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 22)
    }
    
    static func custom24bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 24)
    }
    
    static func custom28bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 28)
    }
    
    static func custom32bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 32)
    }
    
    static func custom40bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 40)
    }
    
    static func custom48bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 48)
    }
    
    static func custom60bold() -> Font {
        return Font.custom("Pretendard-Bold", size: 60)
    }
    
    //SemiBold
    static func custom14semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 14)
    }
    
    static func custom18semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 18)
    }
    
    static func custom20semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", size: 20)
    }
    
    static func custom20black() -> Font {
        return Font.custom("Pretendard-Black", size: 20)
    }
    
    
    //Heavy
    static func custom14heavy() -> Font {
        return Font.custom("Pretendard-ExtraBold", size: 14)
    }
    
    //Black
    static func custom14black() -> Font {
        return Font.custom("Pretendard-Black", size: 14)
    }
    
    static func custom16black() -> Font {
        return Font.custom("Pretendard-Black", size: 16)
    }
    
    static func custom44black() -> Font {
        return Font.custom("Pretendard-Black", size: 44)
    }
    
    static func custom48black() -> Font {
        return Font.custom("Pretendard-Black", size: 48)
    }
    
    static func custom22black() -> Font {
        return Font.custom("Pretendard-Black", size: 22)
    }
    
    static func custom24black() -> Font {
        return Font.custom("Pretendard-Black", size: 24)
    }
    
    
    // swiftlint:disable:next cyclomatic_complexity
    static func setFontSize() -> Double {
        let height = UIScreen.screenHeight
        var size = 1.0
        
        switch height {
        case 480.0: // Iphone 3,4S => 3.5 inch
            size = 0.85
        case 568.0: // iphone 5, SE => 4 inch
            size = 0.9
        case 667.0: // iphone 6, 6s, 7, 8 => 4.7 inch
            size = 0.9
        case 736.0: // iphone 6s+ 6+, 7+, 8+ => 5.5 inch
            size = 0.95
        case 812.0: // iphone X, XS => 5.8 inch, 13 mini, 12, mini
            size = 0.98
        case 844.0: // iphone 14, iphone 13 pro, iphone 13, 12 pro, 12
            size = 1
        case 852.0: // iphone 14 pro
            size = 1
        case 926.0: // iphone 14 plus, iphone 13 pro max, 12 pro max
            size = 1.05
        case 896.0: // iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch, 11 pro max, 11
            size = 1.05
        case 932.0: // iPhone14 Pro Max
            size = 1.08
        default:
            size = 1
        }
        return size
    }
    
    static let semiContent = Font.system(size: 20, weight: .bold, design: .default)
}

struct SubTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.black)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 20)
    }
}
