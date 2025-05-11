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
    private lazy var navBarBuilder = HomeNavigationBarBuilder(base: self)

    // MARK: Components
    
    private let logoBarImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .homeNavBarLogo).withTintColor(.loBlack)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let notificationBarButton = HomeBarButton(image: UIImage(resource: .homeNavBarBell))
    private let searchBarButton = HomeBarButton(image: UIImage(resource: .homeNavBarMagnifier))
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: Navigation Bar
    
    private func setNavigationBar() {
        navBarBuilder.addLeftBarButtonItem(logoBarImageView)
        navBarBuilder.addRightBarButtonItem(notificationBarButton)
        navBarBuilder.addRightBarButtonItem(searchBarButton)
        navBarBuilder.setShadowColor(.background)
        navBarBuilder.build()
    }
    
    // MARK: Layout
        
    private func setAutoLayout() { }
    
    // MARK: Binding
    
    private func setBinding() { }
}

#Preview { UINavigationController(rootViewController: HomeVC()) }
