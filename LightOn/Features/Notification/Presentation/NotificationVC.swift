//
//  NotificationVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit
import Combine

import SnapKit

final class NotificationVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let tableView = NotificationTableView()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.setSnapshot(items: NotificationItem.mockItems)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "알림"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
}

// MARK: - Preview

#Preview { TabBarController() }

