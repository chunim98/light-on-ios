//
//  RecommendListVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/12/25.
//

import UIKit
import Combine

import SnapKit

final class RecommendListVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = GenreDiscoveryDI.shared.makeRecommendListVM()
    
    // MARK: Components
    
    private let tableView = HashtagPerformanceTableView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 선택한 공연 아이디
        let selectedID = tableView
            .selectedModelPublisher(dataSource: tableView.diffableDataSource)
            .map { $0.id }
            .eraseToAnyPublisher()
        
        /// 데이터 로드 트리거
        let trigger = viewDidAppearPublisher
            .map { SessionManager.shared.loginState }
            .eraseToAnyPublisher()
        
        let input = RecommendListVM.Input(trigger: trigger)
        let output = vm.transform(input)
        
        output.performances
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        // 선택한 공연의 상세 페이지로 이동
        selectedID
            .sink { AppCoordinatorBus.shared.navigate(to: .performanceDetail(id: $0)) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { GenreDiscoveryVC() }
