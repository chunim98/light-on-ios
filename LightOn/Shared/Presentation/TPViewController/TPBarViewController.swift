//
//  TPBarViewController.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit

import SnapKit

class TPBarViewController: UIViewController {
    
    // MARK: Properties
    
    let contentLayoutGuide = UILayoutGuide() // 네비게이션바의 높이가 고려된 SafeArea
    
    // MARK: Components
    
    weak var tabBar: TabBarController?
    
    let topSafeAreaView = UIView()
    let navigationBar = TPNavigationBar(height: 50)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    // MARK: Layout
    
    private func setupLayout() {        
        view.addSubview(topSafeAreaView)
        view.addSubview(navigationBar)
        
        view.addLayoutGuide(contentLayoutGuide)
        
        topSafeAreaView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
        contentLayoutGuide.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationBar.snp.bottom)
        }
    }
}

// MARK: - Preview

#Preview { TPBarViewController() }
