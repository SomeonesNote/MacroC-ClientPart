//
//  UIScreen.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

    static func getWidth(_ width: CGFloat) -> CGFloat {
        screenWidth / 390 * width
    }
    static func getHeight(_ height: CGFloat) -> CGFloat {
        screenHeight / 844 * height
    }
    
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

