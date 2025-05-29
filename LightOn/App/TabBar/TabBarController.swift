//
//  TabBarController.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

import SnapKit

final class TabBarController: BaseTabBarController {

    // MARK: Components

    private lazy var homeVC: UIViewController = {
        let vc = HomeVC()
        vc.tabBar = self
        return UINavigationController(rootViewController: vc)
    }()
    private let activityManagementVC = UIViewController() // temp
    private let eventManagementVC = UIViewController() // temp
    private let dashboardVC = UIViewController() // temp

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        bottomSafeAreaView.backgroundColor = .white
        
        activityManagementVC.view.backgroundColor = .orange // temp
        eventManagementVC.view.backgroundColor = .cyan // temp
        dashboardVC.view.backgroundColor = .magenta // temp
        
        tabController.tabs = [
            homeVC,
            activityManagementVC, // temp
            eventManagementVC, // temp
            dashboardVC // temp
        ]
        
        tabController.setupVC(index: 0)
    }
}

// MARK: - Preview

#Preview { TabBarController() }
