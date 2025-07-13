//
//  HomeVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/8/25.
//

import UIKit
import Combine

import SnapKit

final class HomeVC: NavigationBarVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical)
    
    private let notificationBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = .homeNavBarBell.withTintColor(.loBlack)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let searchBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = .homeNavBarMagnifier.withTintColor(.loBlack)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let bannerPageVC = BannerPageVC()
    
    private let recommendHeader = {
        let view = HomeHeaderView()
        view.titleLabel.config.text = "추천 공연"
        return view
    }()
    
    private let spotlightedHeader = {
        let view = HomeHeaderView()
        view.titleLabel.config.text = "주목할 만한 아티스트 공연"
        return view
    }()
    
    private let popularHeader = {
        let view = HomeHeaderView()
        view.titleLabel.config.text = "현재 인기 있는 공연"
        return view
    }()
    
    private let recommendCollectionView = RecommendCollectionView()
    private let spotlightedCollectionView = SpotlightedCollectionView()
    private let popularCollectionView = PopularCollectionView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupBindings()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = .homeNavBarLogo
        
        navigationBar.leftItemHStack.addArrangedSubview(LOSpacer(18))
        navigationBar.leftItemHStack.addArrangedSubview(logoImageView)
        
        navigationBar.rightItemHStack.addArrangedSubview(notificationBarButton)
        navigationBar.rightItemHStack.addArrangedSubview(LOSpacer(9))
        navigationBar.rightItemHStack.addArrangedSubview(searchBarButton)
        navigationBar.rightItemHStack.addArrangedSubview(LOSpacer(18))
        
        recommendCollectionView.setSnapshot(items: RecommendCellItem.mockItems) // temp
        spotlightedCollectionView.setSnapshot(items: SpotlightedCellItem.mockItems) // temp
        popularCollectionView.setSnapshot(items: PopularCellItem.mockItems) // temp
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(bannerPageVC.view)
        contentVStack.addArrangedSubview(recommendHeader)
        contentVStack.addArrangedSubview(recommendCollectionView)
        contentVStack.addArrangedSubview(LOSpacer(18))
        contentVStack.addArrangedSubview(spotlightedHeader)
        contentVStack.addArrangedSubview(spotlightedCollectionView)
        contentVStack.addArrangedSubview(LOSpacer(18))
        contentVStack.addArrangedSubview(popularHeader)
        contentVStack.addArrangedSubview(popularCollectionView)
        contentVStack.addArrangedSubview(LOSpacer(30))
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        bannerPageVC.view.snp.makeConstraints { $0.size.equalTo(view.snp.width) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        notificationBarButton.tapPublisher
            .sink { [weak self] _ in
                let vc = NotificationVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { UINavigationController(rootViewController: HomeVC()) }
#Preview { TabBarController() }
