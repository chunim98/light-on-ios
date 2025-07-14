//
//  GenreDiscoveryVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit
import SwiftUI
import Combine

import SnapKit

final class GenreDiscoveryVC: NavigationBarVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    
    private let upperTabBar = UpperTabBar()
    private let pageVC = PerformanceListPageController()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "공연 목록"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(upperTabBar)
        mainVStack.addArrangedSubview(pageVC.view)
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        upperTabBar.selectedIndexPublisher
            .sink { [weak self] in self?.pageVC.pageIndexBidner(index: $0) }
            .store(in: &cancellables)
        
        pageVC.pageIndexPublisher
            .sink { [weak self] in self?.upperTabBar.selectedIndexBinder(index: $0) }
            .store(in: &cancellables)
        
        pageVC.popularListVC.tagsView.rootView.selectedIndexPublisher
            .sink { print("genreTagsView", $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { TabBarController() }
