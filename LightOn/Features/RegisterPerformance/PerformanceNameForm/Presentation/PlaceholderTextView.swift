//
//  PlaceholderTextView.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PlaceholderTextView: UITextView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 동적 높이 구현
    override var intrinsicContentSize: CGSize {
        let size = CGSize(
            width: super.intrinsicContentSize.width,
            height: .greatestFiniteMagnitude
        )
        let height = max(47, sizeThatFits(size).height)
        return CGSize(width: size.width, height: height)
    }
    
    // MARK: Components
    
    let placeHolderLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .assistive
        return LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 18, vertical: 12)
        )
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        autocapitalizationType = .none  // 자동 대문자 비활성화
        
        textContainerInset = .init(horizontal: 18, vertical: 12)
        textContainer.lineFragmentPadding = .zero // NSTextContainer 여백 제거
        
        font = .pretendard.regular(16)
        textColor = .loBlack
        
        layer.borderColor = UIColor.thumbLine.cgColor
        layer.borderWidth = 1
        
        layer.cornerRadius = 6
        isScrollEnabled = false
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        self.textPublisher.sink { [weak self] text in
            // 텍스트가 입력될 때마다 높이 계산
            self?.invalidateIntrinsicContentSize()
            // 텍스트가 입력되면 플레이스 홀더 숨김
            self?.placeHolderLabel.isHidden = !(text ?? "").isEmpty
        }
        .store(in: &cancellables)
    }
}
