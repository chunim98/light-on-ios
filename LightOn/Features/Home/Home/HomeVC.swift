//
//  HomeVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/8/25.
//

import UIKit
import Combine

import SnapKit

final class HomeVC: TPBarViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Components
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical)
    
    private let notificationBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = .homeNavBarBell.withTintColor(.blackLO)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let searchBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = .homeNavBarMagnifier.withTintColor(.blackLO)
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let bannerPageVC = BannerPageVC()
    private let recommendSectionView = RecommendSectionView()
    private let spotlightedSectionView = SpotlightedSectionView()
    private let popularSectionView = PopularSectionView()
    
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
        
        navigationBar.leftItemHStack.addArrangedSubview(logoImageView)
        navigationBar.rightItemHStack.addArrangedSubview(notificationBarButton)
        navigationBar.rightItemHStack.addArrangedSubview(Spacer(spacing: 9))
        navigationBar.rightItemHStack.addArrangedSubview(searchBarButton)
    }
    
    // MARK: Layout
        
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(bannerPageVC.view)
        contentVStack.addArrangedSubview(recommendSectionView)
        contentVStack.addArrangedSubview(Spacer(spacing: 18))
        contentVStack.addArrangedSubview(spotlightedSectionView)
        contentVStack.addArrangedSubview(Spacer(spacing: 18))
        contentVStack.addArrangedSubview(popularSectionView)
        contentVStack.addArrangedSubview(Spacer(spacing: 30))
        
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
