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
    private let vm = HomeDI.shared.makeHomeVM()
    
    // MARK: Inputs
    
    private let refreshEventSubject = PassthroughSubject<Void, Never>()
    
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
    
    // 로그인 상태에 따라 타이틀 바인딩됨
    private let recentRecommendHeader = HomeHeaderView()
    
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
    
    private let recentRecommendCollectionView = SmallPerformanceCollectionView()
    private let spotlightedCollectionView = MediumPerformanceCollectionView()
    private let popularCollectionView = LargePerformanceCollectionView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupBindings()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshEventSubject.send(())    // 뷰가 보여질 때마다 공연 목록 갱신
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
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(bannerPageVC.view)
        contentVStack.addArrangedSubview(recentRecommendHeader)
        contentVStack.addArrangedSubview(recentRecommendCollectionView)
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
        let selectedRecentRecommend = recentRecommendCollectionView
            .selectedModelPublisher(dataSource: recentRecommendCollectionView.diffableDataSource)
            .map { $0.performanceID }
            .eraseToAnyPublisher()
        
        let selectedSpotlighted = spotlightedCollectionView
            .selectedModelPublisher(dataSource: spotlightedCollectionView.diffableDataSource)
            .map { $0.performanceID }
            .eraseToAnyPublisher()
        
        let selectedPopular = popularCollectionView
            .selectedModelPublisher(dataSource: popularCollectionView.diffableDataSource)
            .map { $0.performanceID }
            .eraseToAnyPublisher()
        
        /// 선택한 공연 ID
        let selectedPerformanceID = Publishers.MergeMany(
            bannerPageVC.selectedIDPublisher,
            selectedRecentRecommend,
            selectedSpotlighted,
            selectedPopular
        ).eraseToAnyPublisher()
        
        let input = HomeVM.Input(
            refreshEvent: refreshEventSubject.eraseToAnyPublisher(),
            selectedPerformanceID: selectedPerformanceID
        )
        
        let output = vm.transform(input)
        
        output.banners
            .sink { [weak self] in self?.bannerPageVC.bindBannerItems($0) }
            .store(in: &cancellables)
        
        output.populars
            .sink { [weak self] in self?.popularCollectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.spotlighteds
            .sink { [weak self] in self?.spotlightedCollectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.recentRecommendeds
            .sink { [weak self] in self?.recentRecommendCollectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.recentRecommendedTitle
            .sink { [weak self] in self?.recentRecommendHeader.titleLabel.config.text = $0 }
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
