//
//  LOTabBarView.swift
//  LightOn
//
//  Created by 신정욱 on 5/8/25.
//

import UIKit
import Combine

final class LOTabBarView: UIStackView {
    
    // MARK: Properties
    
    private let vm = LOTabBarVM()
    private var cancellables = Set<AnyCancellable>()

    // MARK: Components

    private let tabBarButtons: [TabBarButton] = [
        .init(icon: .tabBarHome, title: "홈", index: 0),
        .init(icon: .tabBarNote, title: "공연", index: 1),
        .init(icon: .tabBarPin, title: "지도", index: 2),
        .init(icon: .tabBarUser, title: "마이페이지", index: 3)
    ]
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        tabBarButtons.forEach { addArrangedSubview($0) } // Layout
        setBinding()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // shadowPath로 그림자 렌더링 성능 개선
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configure() {
        backgroundColor = .loWhite
        distribution = .fillEqually
        inset = .init(horizontal: 16, vertical: 14)
        // 그림자 설정
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let selectedIndex = Publishers
            .MergeMany(tabBarButtons.map { $0.indexPublisher })
            .eraseToAnyPublisher()
        
        let input = LOTabBarVM.Input(selectedIndex: selectedIndex)
        let output = vm.transform(input)
        
        // 선택된 탭 버튼 하이라이트
        output.selectedIndex
            .sink { [weak self] in self?.selectedIndexBinder($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binder

extension LOTabBarView {
    private func selectedIndexBinder(_ selectedIndex: Int) {
        tabBarButtons.forEach { $0.selectedIndexBinder(selectedIndex) }
    }
    
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        Publishers
            .MergeMany(tabBarButtons.map { $0.indexPublisher })
            .eraseToAnyPublisher()
    }
}

#Preview {
    LOTabBarView()
}
