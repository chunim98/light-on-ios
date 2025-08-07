//
//  MyPreferredCell.swift
//  LightOn
//
//  Created by 신정욱 on 8/6/25.
//

import UIKit

import Kingfisher
import SnapKit

final class MyPreferredCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let id = "MyPreferredCell"
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.thumbLine.cgColor
        iv.layer.borderWidth = 1
        iv.layer.cornerRadius = 32
        iv.clipsToBounds = true
        iv.snp.makeConstraints { $0.size.equalTo(64) }
        return iv
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .loBlack
        config.alignment = .center
        config.lineHeight = 23
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainVStack)
        mainVStack.addArrangedSubview(imageView)
        mainVStack.addArrangedSubview(LOSpacer(3))
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: Public Configuration
    
    func configure(with item: MyPreferredCellItem?) {
        if let image = item?.image {
            imageView.image = image
        } else {
            let imagePath = URL(string: item?.imagePath ?? "")
            imageView.kf.setImage(with: imagePath)
        }
        
        titleLabel.config.text = item?.title
    }
}

// MARK: - Preview

#Preview {
    let cell = MyPreferredCell()
    cell.configure(with: .init(image: nil, imagePath: nil, title: "아티스트"))
    return cell
}
