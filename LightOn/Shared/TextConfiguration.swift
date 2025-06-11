//
//  TextConfiguration.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

/// 텍스트와 폰트 없이는 아트리뷰트 텍스트 못만듦!!
struct TextConfiguration: Hashable {
    /// 필수적으로 지정할 것, nil이면 생성불가
    var text: String?
    /// 필수적으로 지정할 것, nil이면 생성불가
    var font: UIFont?
    var foregroundColor: UIColor?
    var alignment: NSTextAlignment? = .natural
    var lineHeight: CGFloat?
    /// 퍼센트로 기입할 것 (기본 값: -1%)
    var letterSpacing: CGFloat?     = -0.01
    var paragraphSpacing: CGFloat?
    var underlineStyle: NSUnderlineStyle?
    var underlineColor: UIColor?
}
