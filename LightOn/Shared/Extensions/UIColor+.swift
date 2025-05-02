//
//  UIColor+.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let brand = UIColor(hex: 0x6137DD)
    
    // 아직 사용 예정 없음. (gpt가 추출한 색상이라 부정확함)
    static let brand50  = UIColor(hex: 0xEBE4FA) // 가장 연한 톤
    static let brand100 = UIColor(hex: 0xCDBEF1)
    static let brand200 = UIColor(hex: 0xAD95EA)
    static let brand300 = UIColor(hex: 0x8C6DE3)
    static let brand400 = UIColor(hex: 0x7250DD)
    static let brand500 = UIColor(hex: 0x5937D6) // 중심(기본) 톤
    static let brand600 = UIColor(hex: 0x4E33CF)
    static let brand700 = UIColor(hex: 0x3E2DC5)
    static let brand800 = UIColor(hex: 0x2F29BE)
    static let brand900 = UIColor(hex: 0x1420B3) // 가장 진한 톤
}
