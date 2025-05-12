//
//  MediumEventCardTableCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit

import SnapKit

final class MediumEventCardTableCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "MediumEventCardTableCell"
    
    // MARK: Components
    
    private let mediumEventCardView = MediumEventCardView()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAutoLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(mediumEventCardView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        mediumEventCardView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configuration
    
    func configure(item: (any MediumEventCardItem)?) {
        mediumEventCardView.configure(item: item)
    }
}

#Preview { MediumEventCardTableCell() }
