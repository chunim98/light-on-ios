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
        /// 돋보기 이미지 숨김 상태
        let magnifierHiddenSubject = CurrentValueSubject<Bool, Never>(false)
        
        // 텍스트로 돋보기 숨김 갱신
        textField.textPublisher
            .compactMap { $0.map { !$0.isEmpty } }
            .sink { magnifierHiddenSubject.send($0) }
            .store(in: &cancellables)
        
        // 버튼 탭으로 돋보기 숨김 갱신
        clearButton.tapPublisher
            .map { false }
            .sink { magnifierHiddenSubject.send($0) }
            .store(in: &cancellables)
        
        // 돋보기 상태 바인딩
        magnifierHiddenSubject
            .sink { [weak self] in self?.magnifierImageView.isHiddenWithAnime = $0 }
            .store(in: &cancellables)
        
        // 필드 모두 지우기
        clearButton.tapPublisher
            .sink { [weak self] in self?.textField.text = "" }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MapSearchBar {
    /// 텍스트 퍼블리셔 (지우기 버튼 이벤트까지 고려됨)
    var textPublisher: AnyPublisher<String, Never> {
        Publishers.Merge(
            textField.textPublisher.compactMap { $0 },
            clearButton.tapPublisher.map { "" }
        ).eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { MapSearchBar() }
