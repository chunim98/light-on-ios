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
    private lazy var navigationBarBuilder = HomeNavigationBarBuilder(base: self)

    // MARK: Components
    
    private let contentVStack = UIStackView(.vertical, spacing: 18)
    
    private let notificationBarButton = HomeBarButton(image: UIImage(resource: .homeNavBarBell))
    private let searchBarButton = HomeBarButton(image: UIImage(resource: .homeNavBarMagnifier))
    private let scrollView = UIScrollView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loWhite
        setNavigationBar()
        setAutoLayout()
    }
    
    // MARK: Navigation Bar
    
    private func setNavigationBar() {
        navigationBarBuilder.addRightBarButtonItem(notificationBarButton)
        navigationBarBuilder.addRightBarButtonItem(searchBarButton)
        navigationBarBuilder.build()
    }
    
    // MARK: Layout
        
    private func setAutoLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentVStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    // MARK: Binding
    
    private func setBinding() { }
}

#Preview { UINavigationController(rootViewController: HomeVC()) }
