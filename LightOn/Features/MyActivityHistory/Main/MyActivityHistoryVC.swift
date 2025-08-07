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
    
    private let statsVC = MyStatsVC()
    private let myPreferredVC = MyPreferredVC()
    
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
        addChild(statsVC)
        addChild(myPreferredVC)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(statsVC.view)
        contentVStack.addArrangedSubview(myPreferredVC.view)
        contentVStack.addArrangedSubview(
            LODivider(height: 12, color: .background)
        )
        
        statsVC.didMove(toParent: self)
        myPreferredVC.didMove(toParent: self)
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { MyActivityHistoryVC() }
