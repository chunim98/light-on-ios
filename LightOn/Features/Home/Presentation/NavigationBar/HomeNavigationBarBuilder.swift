//
//  HomeNavigationBarBuilder.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit

import SnapKit

final class HomeNavigationBarBuilder: NavigationBarBuilder {
    
    // MARK: Components
    
    // 네비 바 기본 좌우 패딩이 16 (16+2 = 18)
    private let leftBarButtonsHStack = UIStackView(inset: .init(horizontal: 2))
    private let rightBarButtonsHStack = UIStackView(spacing: 9, inset: .init(horizontal: 2))
    
    private let logoBarImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .homeNavBarLogo).withTintColor(.loBlack)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: Initializer
    
    override init(base: UIViewController?) {
        super.init(base: base)
        setNavigationBarItemsLayout()
    }
    
    // MARK: Layout
    
    private func setNavigationBarItemsLayout() {
        base?.navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: leftBarButtonsHStack
        )
        base?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: rightBarButtonsHStack
        )
        
        leftBarButtonsHStack.addArrangedSubview(logoBarImageView)
        leftBarButtonsHStack.snp.makeConstraints { $0.height.equalTo(27) }
        rightBarButtonsHStack.snp.makeConstraints { $0.height.equalTo(27) }
    }
    
    // MARK: Configuration
    
    func addRightBarButtonItem(_ barButtonItem: UIView) {
        rightBarButtonsHStack.addArrangedSubview(barButtonItem)
    }
}
