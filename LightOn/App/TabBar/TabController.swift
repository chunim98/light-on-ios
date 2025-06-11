//
//  TabController.swift
//  TennisPark
//
//  Created by 신정욱 on 5/26/25.
//

import UIKit

import SnapKit

class TabController: UIViewController {
    
    // MARK: Properties

    var tabs: [UIViewController] = []
    private var selectedIndex = 0
    
    // MARK: Components
    
    let contentVStack = UIStackView(.vertical)
    let contentView = UIView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(contentVStack)
        contentVStack.addArrangedSubview(contentView)
        contentVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: ransition

    func setupVC(index: Int) {
        let selectedVC = tabs[index]
        
        addChild(selectedVC)
        contentView.addSubview(selectedVC.view)
        selectedVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        selectedVC.didMove(toParent: self)
    }
    
    func removeVC(index: Int) {
        let previousVC = tabs[index]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
    }
    
    func transition(to index: Int) {
        guard selectedIndex != index else { return }
        
        let preVC = tabs[selectedIndex]
        let newVC = tabs[index]
        
        addChild(newVC)
        contentView.addSubview(newVC.view)
        newVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // addSubview, removeFromSuperview는
        // transition 메서드가 알아서 처리해줌
        transition(
            from: preVC,
            to: newVC,
            duration: 0.11,
            options: .transitionCrossDissolve
        ) { [weak self] in
            preVC.willMove(toParent: nil)
            preVC.removeFromParent()
            
            newVC.didMove(toParent: self)
            self?.selectedIndex = index
        }
    }
}

// MARK: Binders & Publishers

extension TabController {
    func selectedIndexBinder(_ index: Int) { transition(to: index) }
}
