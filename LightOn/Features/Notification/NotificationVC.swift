//
//  NotificationVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit

import SnapKit

final class NotificationVC: UIViewController {
    
    // MARK: Typealias
    
    typealias Item = TestNotificationItem // temp
    
    // MARK: Properties
    
    private lazy var navigationBarBuilder = NavigationBarBuilder(base: self)
    
    // MARK: Components
    
    private let tableView = NotificationTableView<Item>()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loWhite
        navigationItem.setHidesBackButton(true, animated: false)
        
        // interactivePopGesture 복구
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setNavigationBar()
        setAutoLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.applySnapshot(items: Item.mockItems)
    }
    
    // MARK: Navigation Bar
    
    private func setNavigationBar() {
        navigationBarBuilder.setTitle("알림")
        navigationBarBuilder.build()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
}

// MARK: UIGestureRecognizerDelegate

extension NotificationVC: UIGestureRecognizerDelegate {
    /// 제스처가 시작되기 전에 동작 여부를 결정
    func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

//#Preview { UINavigationController(rootViewController: NotificationVC()) }
#Preview { TabBarVC() }

