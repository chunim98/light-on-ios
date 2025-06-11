//
//  NavigationBar.swift
//  TennisPark
//
//  Created by 신정욱 on 5/26/25.
//

import UIKit

import SnapKit

final class NavigationBar: UIView {
    
    // MARK: Properties
    
    private let height: CGFloat
    
    override var intrinsicContentSize: CGSize {
        let width = super.intrinsicContentSize.width
        return CGSize(width: width, height: height)
    }
    
    // MARK: Components
    
    let leftItemHStack = UIStackView(alignment: .center)
    let rightItemHStack = UIStackView(alignment: .center)
    
    let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(19)
        config.foregroundColor = .blackLO
        return TPLabel(config: config)
    }()
    
    // MARK: Life Cycle

    init(height: CGFloat) {
        self.height = height
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    func setupLayout() {
        addSubview(titleLabel)
        addSubview(leftItemHStack)
        addSubview(rightItemHStack)
        
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        leftItemHStack.snp.makeConstraints { $0.leading.verticalEdges.equalToSuperview() }
        rightItemHStack.snp.makeConstraints { $0.trailing.verticalEdges.equalToSuperview() }
    }
}

// MARK: - Preview

#Preview { NavigationBar(height: 80) }
