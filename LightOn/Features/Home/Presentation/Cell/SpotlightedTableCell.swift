//
//  SpotlightedTableCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit

import SnapKit

final class SpotlightedTableCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "SpotlightedTableCell"
    
    // MARK: Components
    
    private let mediumEventCardView = SpotlightedBaseCell()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mediumEventCardView)
        mediumEventCardView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Public Configuration

    func configure(item: SpotlightedCellItem?) {
        mediumEventCardView.configure(item: item)
    }
}

// MARK: - Preview

#Preview { SpotlightedTableCell() }
