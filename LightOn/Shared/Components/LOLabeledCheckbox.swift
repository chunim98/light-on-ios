//
//  LOLabeledCheckbox.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit
import Combine

import SnapKit

final class LOLabeledCheckbox: UIView {
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .center, spacing: 6)
    private let checkbox = LOCheckbox()
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .caption
        label.font = .pretendard.regular(14)
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if DEBUG
        titleLabel.text = "출입 방법 저장"
        #endif
        
        setAutoLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(mainHStack)
        mainHStack.addArrangedSubview(checkbox)
        mainHStack.addArrangedSubview(titleLabel)
        mainHStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(23)
        }
    }
    
    // MARK: Configure
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var isSelected: Bool {
        get { checkbox.isSelected }
        set { checkbox.isSelected = newValue }
    }
}

// MARK: Publishers

extension LOLabeledCheckbox {
    var isSelectedPublisher: AnyPublisher<Bool, Never> {
        self.checkbox.publisher(for: \.isSelected).eraseToAnyPublisher()
    }
}

#Preview { LOLabeledCheckbox() }
