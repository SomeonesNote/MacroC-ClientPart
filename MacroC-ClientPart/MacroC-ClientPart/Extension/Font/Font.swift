//
//  Font.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import SwiftUI

extension Font {
    
    //Light
    static func custom22light() -> Font {
        return Font.custom("Pretendard-Light", fixedSize: 22 * setFontSize())
    }
    
    //Regular
    static func custom12regular() -> Font {
        return Font.custom("Pretendard-Regulard", fixedSize: 12 * setFontSize())
    }
    
    static func custom13regular() -> Font {
        return Font.custom("Pretendard-Regulard", fixedSize: 13 * setFontSize())
    }
    
    static func custom14regular() -> Font {
        return Font.custom("Pretendard-Regular", fixedSize: 14 * setFontSize())
    }
    
    static func custom16regular() -> Font {
        return Font.custom("Pretendard-Regular", fixedSize: 16 * setFontSize())
    }
    
    static func custom34regular() -> Font {
        return Font.custom("Pretendard-Regulard", fixedSize: 34 * setFontSize())
    }
    
    //SemiBold
    
    static func custom10semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 10 * setFontSize())
    }
    
    static func custom12semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 12 * setFontSize())
    }
    
    static func custom13semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 13 * setFontSize())
    }
    
    static func custom14semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 14 * setFontSize())
    }
    
    static func custom16semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 16 * setFontSize())
    }
    
    static func custom18semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 18 * setFontSize())
    }
    
    static func custom20semibold() -> Font {
        return Font.custom("Pretendard-SemiBold", fixedSize: 20 * setFontSize())
    }
    
    
    //Bold
    static func custom10bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 10 * setFontSize())
    }
    
    static func custom13bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 13 * setFontSize())
    }
    
    static func custom14bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 14 * setFontSize())
    }
    
    static func custom16bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 16 * setFontSize())
    }
    
    static func custom20bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 20 * setFontSize())
    }
    
    static func custom25bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 25 * setFontSize())
    }
    
    static func custom40bold() -> Font {
        return Font.custom("Pretendard-Bold", fixedSize: 40 * setFontSize())
    }
    
    //Heavy
    static func custom13heavy() -> Font {
        return Font.custom("Pretendard-ExtraBold", fixedSize: 13 * setFontSize())
    }
    
    //Black
    static func custom13black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 13 * setFontSize())
    }
    
    static func custom21black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 21 * setFontSize())
    }
    
    static func custom22black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 22 * setFontSize())
    }
    
    static func custom24black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 24 * setFontSize())
    }
    
    static func custom26black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 26 * setFontSize())
    }
    
    static func custom32black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 32 * setFontSize())
    }
    
    static func custom40black() -> Font {
        return Font.custom("Pretendard-Black", fixedSize: 40 * setFontSize())
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
