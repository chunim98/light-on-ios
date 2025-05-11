//
//  HomeNavigationBarBuilder.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit

import SnapKit

final class HomeNavigationBarBuilder: NSObject {
    
    // MARK: Properties
    
    private weak var base: UIViewController?
    private let appearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .loWhite
        appearance.shadowColor = .clear
        return appearance
    }()
    
    // MARK: Components
    
    // 네비 바 기본 좌우 패딩이 16 (16+2 = 18)
    private let leftBarButtonsHStack = UIStackView(inset: .init(horizontal: 2))
    private let rightBarButtonsHStack = UIStackView(spacing: 9, inset: .init(horizontal: 2))
    
    // MARK: Initializer
    
    init(base: UIViewController?) {
        self.base = base
        super.init()
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
        leftBarButtonsHStack.snp.makeConstraints {$0.height.equalTo(27) }
        rightBarButtonsHStack.snp.makeConstraints {$0.height.equalTo(27) }
    }
    
    // MARK: Configuration
    
    func build() {
        base?.navigationController?.navigationBar.standardAppearance = appearance
        base?.navigationController?.navigationBar.compactAppearance = appearance
        base?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setTitle(_ text: String) {
        appearance.titleTextAttributes = [.foregroundColor: UIColor.loBlack]
        base?.title = text
    }
    
    func setTintColor(_ color: UIColor) {
        base?.navigationController?.navigationBar.tintColor = color
    }
    
    func setShadowColor(_ color: UIColor) {
        // width는 네비게이션 바가 알아서 늘림
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(
            x: 0,
            y: 0,
            width: 1,
            height: 1
        )
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image {
            $0.cgContext.setFillColor(color.cgColor)
            $0.cgContext.addRect(rect)
            $0.cgContext.drawPath(using: .fill)
        }
        appearance.shadowImage = image
    }
    
    func addLeftBarButtonItem(_ barButtonItem: UIView) {
        leftBarButtonsHStack.addArrangedSubview(barButtonItem)
    }
    
    func addRightBarButtonItem(_ barButtonItem: UIView) {
        rightBarButtonsHStack.addArrangedSubview(barButtonItem)
    }
}
