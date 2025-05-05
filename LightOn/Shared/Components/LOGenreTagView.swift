//
//  LOGenreTagView.swift
//  LightOn
//
//  Created by 신정욱 on 5/6/25.
//

import UIKit

import SnapKit

final class LOGenreTagView: UIView {
    
    // MARK: Enum
    
    enum TagType {
        case small
        case large
    }
    
    // MARK: Properties
    
    private let tagType: TagType
    
    // MARK: Components
    
    private let contentView = {
        let sv = UIStackView(alignment: .center)
        sv.clipsToBounds = true
        sv.backgroundColor = UIColor(hex: 0xEEE7FB)
        return sv
    }()
    private let label = {
        let label = UILabel()
        label.textColor = .brand
        return label
    }()
    
    // MARK: Life Cycle
    
    init(tagType: TagType = .small) {
        self.tagType = tagType
        super.init(frame: .zero)
        configure()
        setAutoLayout()
    }
    
    convenience init(tagType: TagType = .small, text: String) {
        self.init(tagType: tagType)
        self.label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(contentView)
        contentView.addArrangedSubview(label)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configure
    
    private func configure() {
        if tagType == .small {
            contentView.layer.cornerRadius = 2
            contentView.inset = .init(horizontal: 4, vertical: 2)
            label.font = .pretendard.bold(8)
        } else {
            contentView.layer.cornerRadius = 4
            contentView.inset = .init(horizontal: 8, vertical: 4)
            label.font = .pretendard.bold(14)
        }
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    // MARK: Override
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: (tagType == .small) ? 14 : 25
        )
    }
}

#Preview { LOGenreTagView(tagType: .large, text: "어쿠스틱") }
