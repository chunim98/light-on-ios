//
//  NotificationVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit
import Combine

import SnapKit

final class NotificationVC: UIViewController {
    
    // MARK: Typealias
    
    typealias Item = TestNotificationItem // temp
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let backBarButton = BackBarButton()
    private let tableView = NotificationTableView<Item>()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupNavigationBar()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.setSnapshot(items: Item.mockItems)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .white
    }
    
    // MARK: Navigation Bar
    
    private func setupNavigationBar() {
        // interactivePopGesture 복구
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        let barBuilder = NavigationBarBuilderWithLayout(base: self)
        barBuilder.setLeftBarLayout(leadingInset: 16)
        barBuilder.addLeftBarItem(backBarButton)
        barBuilder.setTitle("알림")
        barBuilder.build()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        backBarButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension NotificationVC: UIGestureRecognizerDelegate {
    /// 제스처가 시작되기 전에 동작 여부를 결정
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { true }
}

// MARK: - Preview

//#Preview { UINavigationController(rootViewController: NotificationVC()) }
#Preview { TabBarVC() }

