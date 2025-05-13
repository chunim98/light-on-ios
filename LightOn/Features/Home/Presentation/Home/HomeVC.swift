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
    
    private let contentVStack = UIStackView(.vertical, spacing: 18, inset: .init(bottom: 30))
    
    private let notificationBarButton = HomeBarButton(image: .homeNavBarBell)
    private let searchBarButton       = HomeBarButton(image: .homeNavBarMagnifier)
    private let scrollView            = UIScrollView()
    private let bannerPageVC          = BannerPageVC()
    private let recommendedEventView  = RecommendedEventSectionView(title: "추천 공연")
    private let spotlightedEventView  = SpotlightedEventSectionView(title: "주목할 만한 아티스트 공연")
    private let popularEventView      = PopularEventSectionView(title: "현재 인기 있는 공연")
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Self Configuration
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
        contentVStack.addArrangedSubview(bannerPageVC.view)
        contentVStack.addArrangedSubview(recommendedEventView)
        contentVStack.addArrangedSubview(spotlightedEventView)
        contentVStack.addArrangedSubview(popularEventView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(TabBarVC.additionalInset)
        }
        contentVStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        bannerPageVC.view.snp.makeConstraints { $0.size.equalTo(view.snp.width) }
    }
    
    // MARK: Binding
    
    private func setBinding() { }
}

#Preview { UINavigationController(rootViewController: HomeVC()) }
