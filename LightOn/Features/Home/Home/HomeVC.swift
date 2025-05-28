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
    
    var tabBar: TabBarVC?
    
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
        tabBar?.bottomSafeAreaView.backgroundColor = .white
        setupDefaults()
        setupBindings()
        setupLayout()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIView.animate(withDuration: 0.15) { [weak self] in
//            self?.tabBar?.tabBarView.snp.updateConstraints { $0.height.equalTo(0) }
//            self?.tabBar?.view.layoutIfNeeded()
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIView.animate(withDuration: 0.15) { [weak self] in
//            self?.tabBar?.tabBarView.snp.updateConstraints { $0.height.equalTo(72) }
//            self?.tabBar?.view.layoutIfNeeded()
//        }
//    }
    
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
#Preview { TabBarVC() }
