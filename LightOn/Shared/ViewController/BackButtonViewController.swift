//
//  BackButtonViewController.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit

class BackButtonViewController: BackableViewController {

    // MARK: Components
    
    let backBarButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(vertical: 8)
        config.image = .backBarButtonArrow
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        navigationBar.leftItemHStack.addArrangedSubview(Spacer(16))
        navigationBar.leftItemHStack.addArrangedSubview(backBarButton)
    }
}
