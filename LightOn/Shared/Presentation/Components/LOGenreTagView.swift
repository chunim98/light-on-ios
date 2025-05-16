//
//  LOGenreTagView.swift
//  LightOn
//
//  Created by 신정욱 on 5/6/25.
//

import UIKit

import SnapKit

final class LOGenreTagView: UIStackView {
    
    // MARK: Enum
    
    enum TagType {
        case small
        case large
    }
    
    // MARK: Properties
    
    private let tagType: TagType
    
    // MARK: Components
    
    private let label = {
        let label = UILabel()
        label.textColor = .brand
        return label
    }()
    
    // MARK: Life Cycle
    
    init(tagType: TagType = .small) {
        self.tagType = tagType
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    convenience init(tagType: TagType = .small, text: String) {
        self.init(tagType: tagType)
        self.label.text = text
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() { addArrangedSubview(label) }
    
    // MARK: Configuration
    
    private func setupDefaults() {
        clipsToBounds = true
        backgroundColor = UIColor(hex: 0xEEE7FB)
        
        if tagType == .small {
            layer.cornerRadius = 2
            inset = .init(horizontal: 4, vertical: 2)
            label.font = .pretendard.bold(8)
        } else {
            layer.cornerRadius = 4
            inset = .init(horizontal: 8, vertical: 4)
            label.font = .pretendard.bold(14)
        }
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
}

#Preview { LOGenreTagView(tagType: .large, text: "어쿠스틱") }
