//
//  TabBarButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class TabBarButton: UIStackView {
    
    // MARK: Properties
    
    let index: Int
    private let icon: UIImage
    private let title: String
    
    // MARK: Components
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let iconView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Life Cycle
    
    init(icon: UIImage, title: String, index: Int) {
        self.index = index
        self.icon = icon
        self.title = title
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        addGestureRecognizer(tapGesture)
        axis = .vertical
        spacing = 7
        
        titleLabel.text = title
        iconView.image = icon
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        self.addArrangedSubview(iconView)
        self.addArrangedSubview(titleLabel)
        iconView.snp.makeConstraints { $0.height.equalTo(20) }
    }
}

// MARK: Binders & Publishers

extension TabBarButton {
    func selectedIndexBinder(_ selectedIndex: Int) {
        let isSelected     = (index == selectedIndex)
        let color: UIColor = isSelected ? .brand : .assistive
        let font:  UIFont  = isSelected ? .pretendard.bold(13) : .pretendard.medium(13)
        
        titleLabel.font = font
        titleLabel.textColor = color
        iconView.image = icon.withTintColor(color)
    }
    
    var indexPublisher: AnyPublisher<Int, Never> {
        tapGesture.tapPublisher
            .compactMap { [weak self] _ in self?.index }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { TabBarButton(icon: .tabBarPin, title: "공연지도", index: 0) }
