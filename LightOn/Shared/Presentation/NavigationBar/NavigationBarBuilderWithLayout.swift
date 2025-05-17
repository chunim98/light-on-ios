//
//  NavigationBarItemBuilder.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit

import SnapKit

final class NavigationBarBuilderWithLayout: NavigationBarBuilder {
    
    // MARK: Components
    
    private let leftBarItemsHStack = UIStackView(
        alignment: .center,
        inset: .init(leading: -16) // 네비 바 기본 좌우 패딩이 16
    )
    private let rightBarItemsHStack = UIStackView(
        alignment: .center,
        inset: .init(trailing: -16) // 네비 바 기본 좌우 패딩이 16
    )
    
    // MARK: Initializer
    
    override init(base: UIViewController?) {
        super.init(base: base)
        setNavigationBarItemsLayout()
    }
    
    // MARK: Layout
    
    private func setNavigationBarItemsLayout() {
        base?.navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: leftBarItemsHStack
        )
        base?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: rightBarItemsHStack
        )
        leftBarItemsHStack.snp.makeConstraints { $0.height.lessThanOrEqualTo(27) }
        rightBarItemsHStack.snp.makeConstraints { $0.height.lessThanOrEqualTo(27) }
    }
    
    // MARK: Public Configuration

    func setLeftBarLayout(
        spacing: CGFloat? = nil,
        leadingInset inset: CGFloat? = nil
    ) {
        if let spacing { leftBarItemsHStack.spacing = spacing }
        if let inset {
            leftBarItemsHStack.inset =
            leftBarItemsHStack.inset + .init(leading: inset)
        }
    }
    
    func setRightBarLayout(
        spacing: CGFloat? = nil,
        trailingInset inset: CGFloat? = nil
    ) {
        if let spacing { rightBarItemsHStack.spacing = spacing }
        if let inset {
            rightBarItemsHStack.inset =
            rightBarItemsHStack.inset + .init(trailing: inset)
        }
    }
    
    func addLeftBarItem(_ barItem: UIView) {
        leftBarItemsHStack.addArrangedSubview(barItem)
    }
    
    func addRightBarItem(_ barItem: UIView) {
        rightBarItemsHStack.addArrangedSubview(barItem)
    }
}
