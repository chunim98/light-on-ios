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

    static let brand = UIColor(hex: 0x6137DD)       // 브랜드 메인 컬러
    static let pressed = UIColor(hex: 0x432ACE)     // 버튼이 눌렸을 때 컬러
    static let loBlack = UIColor(hex: 0x262626)     // 기본 블랙 (0x000000은 사용 안 함)
    static let loWhite = UIColor(hex: 0xFFFFFF)     // 기본 화이트
    static let disable = UIColor(hex: 0xE9E9E9)     // 비활성화 상태(Disabled) 컬러
    static let caption = UIColor(hex: 0x555555)     // 캡션(보조 설명) 텍스트 컬러
    static let assistive = UIColor(hex: 0xC4C4C4)   // 접근성·보조 요소용 컬러
    static let destructive = UIColor(hex: 0xE63736) // 파괴적 액션(삭제 등) 컬러
    static let background = UIColor(hex: 0xF5F5F5)  // 기본 배경 컬러
}
