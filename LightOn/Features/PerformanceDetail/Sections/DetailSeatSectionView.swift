//
//  DetailSeatSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

final class DetailSeatSectionView: UIStackView {

    // MARK: Components
    
    private let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        config.text = "좌석 정보"
        return TPLabel(config: config)
    }()
    
    let descriptionLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.paragraphSpacing = 8
        config.lineHeight = 26
        config.text =
        """
        • 유료공연 (R석:10,000원/S석:8,000원/A석:4,000원)
        • 자율좌석
        • 지정좌석
        """ // temp
        
        let label = TPLabel(config: config)
        label.numberOfLines = .max
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 18, vertical: 40)
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(Spacer(16))
        addArrangedSubview(descriptionLabel)
    }
}
