//
//  MediumPerformanceTableCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit

import SnapKit

final class MediumPerformanceTableCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "MediumPerformanceTableCell"
    
    // MARK: Components
    
    private let mediumEventCardView = MediumPerformanceBaseCell()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaults()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { selectionStyle = .none }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mediumEventCardView)
        mediumEventCardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(bottom: 10) + UIEdgeInsets(horizontal: 18)
            )
        }
    }
    
    // MARK: Public Configuration

    func configure(item: MediumPerformanceCellItem?) {
        mediumEventCardView.configure(item: item)
    }
}

// MARK: - Preview

#Preview { MediumPerformanceTableCell() }
