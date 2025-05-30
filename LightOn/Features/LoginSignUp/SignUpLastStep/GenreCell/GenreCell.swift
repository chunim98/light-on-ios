//
//  GenreCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

import SnapKit

final class GenreCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let id = "GenreCell"

    // MARK: Components
    
    private let thumbnailView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .background
        iv.layer.cornerRadius = 101/2
        iv.clipsToBounds = true
        
        iv.layer.borderColor = UIColor.clear.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private let genreTextLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(20)
        config.lineHeight = 22
        return TPLabel(config: config)
    }()
    
    private let overlayLayer = CALayer()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        overlayLayer.frame = thumbnailView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        thumbnailView.layer.addSublayer(overlayLayer)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(thumbnailView)
        thumbnailView.addSubview(genreTextLabel)
        
        thumbnailView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(101)
        }
        genreTextLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: Style
    
    private func setupStyle(_ style: GenreCellStyle) {
        genreTextLabel.config.foregroundColor = style.genreTextColor
        thumbnailView.layer.borderColor = style.strokeColor
        overlayLayer.backgroundColor = style.overlayColor
    }
    
    // MARK: Public Configuration
    
    func configure(_ item: GenreCellItem?) {
        setupStyle((item?.isSelected ?? false) ? .selected : .normal)
        genreTextLabel.config.text = item?.genreText
        thumbnailView.image = item?.thumbnailImage
    }
}

// MARK: - Preview

#Preview { GenreCell() }
