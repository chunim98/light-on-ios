//
//  MyActivityHistoryVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyActivityHistoryVC: BackButtonVC {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let scrollView = ResponsiveScrollView()
    private let contentVStack = UIStackView(.vertical)
    
    private let headerView = MyActivityHistoryHeaderView()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "내 활동 내역"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(headerView)
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { MyActivityHistoryVC() }
