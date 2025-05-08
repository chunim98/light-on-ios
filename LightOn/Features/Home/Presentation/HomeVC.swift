//
//  HomeVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/8/25.
//

import UIKit
import Combine

import SnapKit

final class HomeVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()

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
    
    private let notificationBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .homeNavBarBell).withTintColor(.loBlack)
        config.imagePadding = .zero
        return UIButton(configuration: config)
    }()
    
    private let searchBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .homeNavBarMagnifier).withTintColor(.loBlack)
        config.imagePadding = .zero
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSafeAreaInsets = .init(top: 50)
        setNavigationBar(
            leftBarButtonItems: [UIBarButtonItem(customView: leftBarButtonsHStack)],
            rightBarButtonItems: [UIBarButtonItem(customView: rightBarButtonsHStack)]
        )
        setNavigationBarItemsLayout()
    }
    
    // MARK: Layout
    
    private func setNavigationBarItemsLayout() {
        leftBarButtonsHStack.addArrangedSubview(logoBarImageView)
        rightBarButtonsHStack.addArrangedSubview(notificationBarButton)
        rightBarButtonsHStack.addArrangedSubview(searchBarButton)
        logoBarImageView.snp.makeConstraints { $0.height.equalTo(27) }
        notificationBarButton.snp.makeConstraints { $0.size.equalTo(27) }
        searchBarButton.snp.makeConstraints { $0.size.equalTo(27) }
    }
    
    private func setAutoLayout() { }
    
    // MARK: Binding
    
    private func setBinding() { }
}

#Preview { UINavigationController(rootViewController: HomeVC()) }
