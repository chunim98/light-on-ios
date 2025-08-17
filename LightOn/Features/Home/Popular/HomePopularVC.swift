//
//  HomePopularVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/17/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class HomePopularVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = HomeDI.shared.makeHomePopularVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    
    /// 버튼 있는 헤더 뷰
    private let headerView = {
        let view = HomeHeaderView()
        view.titleLabel.config.text = "현재 인기 있는 공연"
        return view
    }()
    
    private let collectionView = LargePerformanceCollectionView()
    
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
        let input = HomePopularVM.Input(trigger: viewDidAppearPublisher)
        let output = vm.transform(input)
        
        output.performances
            .sink { [weak self] in self?.collectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension HomePopularVC {
    /// 선택한 공연 ID 퍼블리셔
    var selectedIDPublisher: AnyPublisher<Int, Never> {
        collectionView
            .selectedModelPublisher(dataSource: collectionView.diffableDataSource)
            .map { $0.performanceID }
            .eraseToAnyPublisher()
    }
}
