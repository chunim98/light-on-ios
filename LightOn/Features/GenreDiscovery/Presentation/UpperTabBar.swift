//
//  UpperTabBar.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class UpperTabBar: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let selectedIndexSubject = PassthroughSubject<Int, Never>()
    
    // MARK: Components

    private let popularButton = {
        let button = UpperTabBarButton()
        button.setTitle("인기 공연")
        button.isSelected = true
        return button
    }()
    
    private let recentRecommendButton = UpperTabBarButton()
    
    private let baseIndicator = {
        let view = LODivider(height: 2, color: .background)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let tintIndicator = {
        let view = LODivider(height: 2, color: .brand)
        view.isUserInteractionEnabled = false
        return view
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
    
    private func setupDefaults() { distribution = .fillEqually }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(popularButton)
        addArrangedSubview(recentRecommendButton)
        
        addSubview(baseIndicator)
        baseIndicator.addSubview(tintIndicator)
        
        self.snp.makeConstraints { $0.height.equalTo(40) }
        baseIndicator.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        tintIndicator.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.leading.bottom.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedIndex = Publishers.Merge(
            popularButton.tapPublisher.map { _ in 0 },
            recentRecommendButton.tapPublisher.map { _ in 1 }
        ).eraseToAnyPublisher()
        
        // 내부 바인딩
        selectedIndex
            .sink { [weak self] in self?.selectedIndexBinder(index: $0) }
            .store(in: &cancellables)
        
        // 외부 방출
        selectedIndex
            .sink { [weak self] in self?.selectedIndexSubject.send($0) }
            .store(in: &cancellables)
        
        /// 로그인 상태별 버튼 타이틀
        SessionManager.shared.loginStatePublisher
            .map { $0 == .login ? "추천 공연" : "최신 공연" }
            .sink { [weak self] in self?.recentRecommendButton.setTitle($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension UpperTabBar {
    /// 선택된 버튼에 틴트 효과 적용
    func selectedIndexBinder(index: Int) {
        // 버튼 상태 갱신
        popularButton.isSelected = (index == 0)
        recentRecommendButton.isSelected = (index == 1)
        
        // 인디케이터 바 위치 갱신
        let inset = (index == 0) ? 0 : bounds.width/2
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.tintIndicator.snp.updateConstraints {
                $0.leading.equalToSuperview().inset(inset)
            }
            self?.baseIndicator.layoutIfNeeded()
        }
    }
    
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        selectedIndexSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { UpperTabBar() }
