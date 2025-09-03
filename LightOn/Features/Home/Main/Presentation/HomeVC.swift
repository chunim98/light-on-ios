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
    private let vm = HomeVM()
    
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
    
    /// 배너 페이지 섹션
    private let bannerPageVC = BannerPageVC()
    
    /// 추천 or 최신 공연 섹션
    private let recentRecommendedVC = HomeRecentRecommendedVC()
    
    /// 주목받은 아티스트 공연 섹션
    private let spotlightedVC = HomeSpotlightedVC()
    
    /// 인기 공연 섹션
    private let popularVC = HomePopularVC()
    
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
         
        #warning("미구현 기능의 버튼 제외")
        // navigationBar.rightItemHStack.addArrangedSubview(notificationBarButton)
        // navigationBar.rightItemHStack.addArrangedSubview(LOSpacer(9))
        // navigationBar.rightItemHStack.addArrangedSubview(searchBarButton)
        // navigationBar.rightItemHStack.addArrangedSubview(LOSpacer(18))
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(bannerPageVC)
        addChild(recentRecommendedVC)
        addChild(spotlightedVC)
        addChild(popularVC)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(bannerPageVC.view)
        contentVStack.addArrangedSubview(recentRecommendedVC.view)
        contentVStack.addArrangedSubview(LOSpacer(18))
        contentVStack.addArrangedSubview(spotlightedVC.view)
        contentVStack.addArrangedSubview(LOSpacer(18))
        contentVStack.addArrangedSubview(popularVC.view)
        contentVStack.addArrangedSubview(LOSpacer(30))
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        
        bannerPageVC.didMove(toParent: self)
        recentRecommendedVC.didMove(toParent: self)
        spotlightedVC.didMove(toParent: self)
        popularVC.didMove(toParent: self)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = HomeVM.Input()
        let output = vm.transform(input)
        
        // 선택한 공연의 상세 페이지로 이동
        Publishers.MergeMany(
            bannerPageVC.selectedIDPublisher,
            recentRecommendedVC.selectedIDPublisher,
            spotlightedVC.selectedIDPublisher,
            popularVC.selectedIDPublisher
        )
        .sink { AppCoordinatorBus.shared.navigate(to: .performanceDetail(id: $0)) }
        .store(in: &cancellables)
        
        // [임시] 알림 화면 이동
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
