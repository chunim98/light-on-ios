//
//  LOTextField.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit
import Combine

import CombineCocoa

class LOTextField: UITextField {
    
    // MARK: Properties
    
    private let inset = UIEdgeInsets(horizontal: 18, vertical: 12)
    
    /// 직접 할당할 경우, `textChangesPublisher`방출
    override var text: String? { didSet { assignTextSubject.send(text) } }
    
    // MARK: Subjects
    
    /// 텍스트 직접 할당 서브젝트(입력용)
    private let assignTextSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        autocapitalizationType = .none  // 자동 대문자 비활성화
        textContentType = .oneTimeCode  // 강력한 비번 생성 방지
        
        font = .pretendard.regular(16)
        textColor = .caption
        
        layer.borderColor = UIColor.thumbLine.cgColor
        layer.borderWidth = 1
        
        backgroundColor = .white
        layer.cornerRadius = 6
        clipsToBounds = true
        
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: inset) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: inset) }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: inset) }
    
    // MARK: Public Configuration
    
    func setPlaceHolder(_ text: String) {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .assistive
        config.lineHeight = 23
        config.text = text
        
        attributedPlaceholder = .init(config: config)
    }
}

// MARK: Binders & Publishers

extension LOTextField {
    /// 모든 텍스트 변경에 대응한 퍼블리셔
    /// - 사용자 편집 이벤트
    /// - 값 직접 할당 이벤트
    var textChangesPublisher: AnyPublisher<String?, Never> {
        Publishers.Merge(
            assignTextSubject.eraseToAnyPublisher(),
            textPublisher
        )
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LOTextField() }

