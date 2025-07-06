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
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .background
        iv.layer.cornerRadius = 101/2
        iv.clipsToBounds = true
        
        iv.layer.borderColor = UIColor.clear.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(20)
        config.lineHeight = 22
        return LOLabel(config: config)
    }()
    
    private let overlayLayer = CALayer()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        overlayLayer.frame = imageView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(nil)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        imageView.layer.addSublayer(overlayLayer)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(101)
        }
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: Style
    
    private func setupStyle(_ style: GenreCellStyle) {
        titleLabel.config.foregroundColor = style.genreTextColor
        imageView.layer.borderColor = style.strokeColor
        overlayLayer.backgroundColor = style.overlayColor
    }
    
    // MARK: Public Configuration
    
    func configure(_ item: GenreCellItem?) {
        setupStyle((item?.isSelected ?? false) ? .selected : .normal)
        titleLabel.config.text = item?.title
        imageView.image = item?.image
    }
}

// MARK: - Preview

#Preview { GenreCell() }
