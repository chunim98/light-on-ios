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
        
        /// 최초 데이터 로드 트리거
        ///
        /// 최초 한 번은 viewDidAppear와 loginState가 함께 준비됐을 때 방출
        let initial = Publishers
            .CombineLatest(viewDidAppearPublisher, loginState)
            .map { _, state in state }
            .first() // 1회 방출 후 종료
            .eraseToAnyPublisher()
        
        /// 이후 데이터 로드 트리거
        ///
        /// 이후에는 viewDidAppear 발생 시점마다 방출
        let subsequent = viewDidAppearPublisher
            .map { SessionManager.shared.loginState }
            .eraseToAnyPublisher()
        
        /// 최종 데이터 로드 트리거
        ///
        /// - 최초 한 번은 viewDidAppear와 loginState가 함께 준비됐을 때 방출
        /// - 이후에는 viewDidAppear 발생 시점마다 방출
        let trigger = initial
            .append(subsequent)
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
