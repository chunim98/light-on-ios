//
//  RecommendListVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/12/25.
//

import UIKit
import Combine

import SnapKit

final class RecommendListVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let performanceTableView = HashtagPerformanceTableView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(performanceTableView)
        performanceTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
//        Just(HashtagPerformanceCellItem.mocks)
//            .sink { [weak self] in self?.performanceTableView.setSnapshot(items: $0) }
//            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { GenreDiscoveryVC() }
