//
//  TabBarButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class TabBarButton: UIButton {
    
    // MARK: Properties
    
    private let image: UIImage
    private let title: String
    
    var titleConfig = TextConfiguration() { didSet {
        configuration?.attributedTitle = .init(textConfig: titleConfig)
    } }

    // MARK: Life Cycle
    
    init(image: UIImage, title: String, tag: Int) {
        self.image = image
        self.title = title
        super.init(frame: .zero)
        self.tag = tag
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleConfig.text = title
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = .init(textConfig: titleConfig)
        config.baseBackgroundColor = .clear
        config.imagePlacement = .top
        config.contentInsets = .zero
        config.imagePadding = 7
        configuration = config
        
        configurationUpdateHandler = { [weak self] in
            let color: UIColor = $0.isSelected ? .brand : .assistive
            let font:  UIFont  = $0.isSelected ? .pretendard.bold(13) : .pretendard.medium(13)
            
            $0.configuration?.image = self?.image.withTintColor(color)
            self?.titleConfig.foregroundColor = color
            self?.titleConfig.font = font
        }

        addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }

    // MARK: Event Handling
    
    @objc private func handleTapEvent() { self.isSelected.toggle() }
}

// MARK: Binders & Publishers

extension TabBarButton {
    func selectedIndexBinder(_ index: Int) { isSelected = (tag == index) }
    
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        self.tapPublisher.compactMap { [weak self] _ in self?.tag }.eraseToAnyPublisher()
    }
}
