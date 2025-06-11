//
//  NavigationBarBuilder.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

class NavigationBarBuilder: NSObject {
    
    // MARK: Properties
    
    weak var base: UIViewController?
    let appearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        // #DEDEDE를 알파0.3으로 쓰면, 최종이 #F5F5F5(.background)
        appearance.shadowColor = UIColor(hex: 0xDEDEDE)
        return appearance
    }()
    
    // MARK: Initializer
    
    init(base: UIViewController?) {
        self.base = base
        super.init()
    }
    
    // MARK: Configuration
    
    /// 네비게이션 바 구성의 제일 마지막 단계에 실행되어야 합니다.
    func build() {
        base?.navigationController?.navigationBar.standardAppearance = appearance
        base?.navigationController?.navigationBar.compactAppearance = appearance
        
        appearance.shadowColor = .clear // 스크롤이 화면 최상단일 때, 그림자 숨기기
        base?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setTitle(_ text: String) {
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.loBlack,
            .font: UIFont.pretendard.semiBold(19)!
        ]
        base?.title = text
    }
    
    func setTintColor(_ color: UIColor) {
        base?.navigationController?.navigationBar.tintColor = color
    }
}
