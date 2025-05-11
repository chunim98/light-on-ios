//
//  TabBarVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit
import Combine

import SnapKit

final class TabBarVC: UITabBarController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let loTabBarView = LOTabBarView()
    private let bottomSafeAreaCoverView = {
        let view = UIView()
        view.backgroundColor = .loWhite
        return view
    }()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setAutoLayout()
        setBinding()
    }
    
    // MARK: Configuration
    
    private func configure() {
        #if DEBUG
        let vc = ViewController()
        let vc2 = UINavigationController(rootViewController: HomeVC())
        let vc3 = UIViewController()
        let vc4 = UIViewController()
        vc3.view.backgroundColor = .orange
        vc4.view.backgroundColor = .magenta
        self.viewControllers = [vc, vc2, vc3, vc4]
        #endif
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        tabBar.addSubview(loTabBarView)
        tabBar.addSubview(bottomSafeAreaCoverView)
        
        loTabBarView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(72)
        }
        bottomSafeAreaCoverView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(loTabBarView.snp.bottom)
        }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        // loTabBarView 선택값을 컨트롤러에 전달
        loTabBarView.selectedIndexPublisher
            .assign(to: \.selectedIndex, on: self)
            .store(in: &cancellables)
    }
}

#Preview { TabBarVC() }
