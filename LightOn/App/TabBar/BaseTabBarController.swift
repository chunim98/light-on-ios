//
//  BaseTabBarController.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit
import Combine

import SnapKit

class BaseTabBarController: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let tabBarHeight: CGFloat = 72

    // MARK: Components
    
    let bottomSafeAreaView = UIView()
    let tabController = TabController()
    let tabBarView = TabBarView()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(tabController.view)
        view.addSubview(tabBarView)
        view.addSubview(bottomSafeAreaView)
        
        tabController.view.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
        tabBarView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(tabBarHeight)
        }
        bottomSafeAreaView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(tabBarView.snp.bottom)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        tabBarView.selectedIndexPublisher
            .sink { [weak self] in self?.tabController.selectedIndexBinder($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Public Configuration
    
    func setIsTabBarHidden(_ bool: Bool) {
        UIView.animate(withDuration: 0.11) { [weak self, tabBarHeight] in
            let height = bool ? 0 : tabBarHeight
            self?.tabBarView.snp.updateConstraints { $0.height.equalTo(height) }
            self?.tabBarView.clipsToBounds = bool
            self?.view.layoutIfNeeded()
        } 
    }
}
