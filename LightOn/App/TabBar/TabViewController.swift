//
//  TabViewController.swift
//  TennisPark
//
//  Created by 신정욱 on 5/26/25.
//


import UIKit

class TabViewController: UIViewController {
    
    // MARK: Properties

    var tabs: [UIViewController] = []
    private var selectedIndex = 0
    
    // MARK: Helper Methods

    func setupVC(index: Int) {
        let selectedVC = tabs[index]
        
        addChild(selectedVC)
        view.addSubview(selectedVC.view)
        selectedVC.view.frame = view.bounds
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
        newVC.view.frame = view.bounds // 미리 프레임은 잡아주기
        
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

extension TabViewController {
    func selectedIndexBinder(_ index: Int) { transition(to: index) }
}
