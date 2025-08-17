//
//  HomeRecentRecommendedVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/17/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class HomeRecentRecommendedVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = HomeDI.shared.makeHomeRecentRecommendedVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    
    /// 버튼 있는 헤더 뷰 (로그인 여부에 따라 타이틀 바인딩)
    private let headerView = HomeHeaderView()
    
    private let collectionView = SmallPerformanceCollectionView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(headerView)
        mainVStack.addArrangedSubview(collectionView)
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 로그인 상태
        let loginState = SessionManager.shared.loginStatePublisher
            .filter { $0 != .unknown }
            .eraseToAnyPublisher()
        
        /// 데이터 로드 트리거
        let trigger = Publishers
            .CombineLatest(viewDidAppearPublisher, loginState)
            .debounce(for: 0.15, scheduler: DispatchQueue.main)
            .map { _, state in state }
            .eraseToAnyPublisher()
        
        let input = HomeRecentRecommendedVM.Input(trigger: trigger)
        let output = vm.transform(input)
        
        output.performances
            .sink { [weak self] in self?.collectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        // 로그인 여부에 따라 헤더 타이틀 표시
        loginState
            .map { $0 == .login ? "추천 공연" : "최신 공연" }
            .sink { [weak self] in self?.headerView.titleLabel.config.text = $0 }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension HomeRecentRecommendedVC {
    /// 선택한 공연 ID 퍼블리셔
    var selectedIDPublisher: AnyPublisher<Int, Never> {
        collectionView
            .selectedModelPublisher(dataSource: collectionView.diffableDataSource)
            .map { $0.performanceID }
            .eraseToAnyPublisher()
    }
}
