//
//  TabBarController.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

import SnapKit

final class TabBarController: TabController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components

    let tabBarView = TabBarView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        tabs = [
            UINavigationController(rootViewController: {
                let vc = HomeVC()
                vc.tabBar = self
                return vc
            }()),
            UINavigationController(rootViewController: {
                let vc = GenreDiscoveryVC()
                vc.tabBar = self
                return vc
            }()),
            UINavigationController(rootViewController: {
                let vc = NavigationBarVC()
                vc.tabBar = self
                return vc
            }()),
            UINavigationController(rootViewController: {
                let vc = MyPageVC()
                vc.tabBar = self
                return vc
            }()),
        ]
        setupVC(index: 0)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(tabBarView)
        contentVStack.addArrangedSubview(LODivider(color: .white))
        
        tabBarView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(72)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        tabBarView.selectedIndexPublisher
            .sink { [weak self] in self?.transition(to: $0) }
            .store(in: &cancellables)
    }
    
    // MARK: Public Configuration
    
    func setTabBarHidden(_ bool: Bool) {
        UIView.animate(withDuration: 0.11) { [weak self] in
            let height = bool ? 0 : 72
            self?.tabBarView.snp.updateConstraints { $0.height.equalTo(height) }
            self?.tabBarView.clipsToBounds = bool
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Preview

#Preview { TabBarController() }
