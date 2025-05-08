//
//  UIViewController+.swift
//  LightOn
//
//  Created by 신정욱 on 5/8/25.
//

import UIKit

extension UIViewController {
    func setNavigationBar(
        backBarButtonItem: UIBarButtonItem? = nil,
        leftBarButtonItems: [UIBarButtonItem]? = nil,
        rightBarButtonItems: [UIBarButtonItem]? = nil,
        title: String? = nil,
        titleImage: UIImage? = nil
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .loWhite
        appearance.shadowColor = .clear
        
        // 네비게이션 바 구성
        if let title {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.loBlack]
            navigationController?.navigationBar.tintColor = .loBlack
            self.title = title
        }
        if let titleImage {
            navigationItem.titleView = UIImageView(image: titleImage)
        }
        if let backBarButtonItem {
            navigationItem.backBarButtonItem = backBarButtonItem
        }
        if let leftBarButtonItems {
            navigationItem.leftBarButtonItems = leftBarButtonItems
        }
        if let rightBarButtonItems {
            navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
