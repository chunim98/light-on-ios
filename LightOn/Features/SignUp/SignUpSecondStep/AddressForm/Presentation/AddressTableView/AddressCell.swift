//
//  AddressCell.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit

import SnapKit

final class AddressCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "AddressCell"
    
    // MARK: Components
    
    private let label = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .loBlack
        config.lineHeight = 23
        return LOPaddingLabel(
            configuration: config,
            padding: .init(edges: 12)
        )
    }()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(text: nil)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { selectionStyle = .none }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: Public Configuration
    
    func configure(text: String?) { label.config.text = text }
}
