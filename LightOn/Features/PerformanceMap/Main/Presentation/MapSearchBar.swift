//
//  MapSearchBar.swift
//  LightOn
//
//  Created by 신정욱 on 7/26/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MapSearchBar: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let textField = {
        var config = AttrConfiguration()
        config.font = .pretendard.medium(16)
        config.foregroundColor = .assistive
        config.text = "어디서 공연을 보시나요?"
        let tf = UITextField()
        tf.attributedPlaceholder = .init(config: config)
        tf.autocapitalizationType = .none   // 자동 대문자 비활성화
        tf.textContentType = .oneTimeCode   // 강력한 비번 생성 방지
        tf.font = .pretendard.medium(16)
        tf.textColor = .caption
        return tf
    }()
    
    private let clearButton = {
        var config = UIButton.Configuration.plain()
        config.image = .mapCrossFill
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let magnifierImageView = {
        let iv = UIImageView(image: .mapMagnifier)
        iv.backgroundColor = .white
        iv.contentMode = .center
        return iv
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 20)
        alignment = .center
        spacing = 20
        
        layer.borderColor = UIColor.brand.cgColor
        layer.borderWidth = 2
        
        backgroundColor = .white
        layer.cornerRadius = 27
        clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(textField)
        addArrangedSubview(clearButton)
        addSubview(magnifierImageView)
        
        self.snp.makeConstraints { $0.height.equalTo(54) }
        magnifierImageView.snp.makeConstraints { $0.edges.equalTo(clearButton) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 텍스트 모두 지우기 이벤트
        let clearEvent = clearButton.tapPublisher
        
        /// 돋 보기 뷰 표시 여부
        let magnifierHiddenByText = textField.textPublisher
            .compactMap { $0.map { !$0.isEmpty } }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let magnifierHiddenByTap = clearEvent
            .map { false }
            .eraseToAnyPublisher()
        
        Publishers.Merge(magnifierHiddenByText, magnifierHiddenByTap)
            .print()
            .sink { [weak self] in self?.magnifierImageView.isHiddenWithAnime = $0 }
            .store(in: &cancellables)
        
        clearEvent
            .sink { [weak self] in self?.textField.text = "" }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { MapSearchBar() }
