//
//  UIFont+.swift
//  LightOn
//
//  Created by 신정욱 on 5/3/25.
//

import UIKit

extension UIFont {
    struct Pretendard {
        func thin       (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-Thin", size: size) }
        func semiBold   (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-SemiBold", size: size) }
        func regular    (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-Regular", size: size) }
        func medium     (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-Medium", size: size) }
        func light      (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-Light", size: size) }
        func extraLight (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-ExtraLight", size: size) }
        func extraBold  (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-ExtraBold", size: size) }
        func bold       (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-Bold", size: size) }
        func black      (_ size: CGFloat) -> UIFont! { UIFont(name: "Pretendard-Black", size: size) }
    }
    
    static let pretendard = Pretendard()
}
