//
//  TabBarVC.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

import SnapKit

final class TabBarVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Components
    
    private let tabVC = TabViewController()
    let tabBarView = TabBarView()
    let bottomSafeAreaView = UIView()

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
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        activityManagementVC.view.backgroundColor = .orange // temp
        eventManagementVC.view.backgroundColor = .cyan // temp
        dashboardVC.view.backgroundColor = .magenta // temp
        
        tabVC.tabs = [
            homeVC,
            activityManagementVC, // temp
            eventManagementVC, // temp
            dashboardVC // temp
        ]
        tabVC.setupVC(index: 0)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(tabVC.view)
        view.addSubview(tabBarView)
        view.addSubview(bottomSafeAreaView)
        
        tabVC.view.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
        tabBarView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(72)
        }
        bottomSafeAreaView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(tabBarView.snp.bottom)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        tabBarView.selectedIndexPublisher
            .sink { [weak self] in self?.tabVC.selectedIndexBinder($0) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { TabBarVC() }
