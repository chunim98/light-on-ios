//
//  TabBarView.swift
//  TennisPark
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit
import Combine

final class TabBarView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Output Subjects
    
    fileprivate let selectedIndexSubject = CurrentValueSubject<Int, Never>(0)

    // MARK: Components

    private let tabBarButtons: [TabBarButton] = [
        .init(image: .tabBarHome, title: "홈", tag: 0),
        .init(image: .tabBarNote, title: "공연", tag: 1),
        .init(image: .tabBarPin,  title: "지도", tag: 2),
        .init(image: .tabBarUser, title: "마이페이지", tag: 3)
    ]
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // shadowPath로 그림자 렌더링 성능 개선
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 16, vertical: 14)
        distribution = .fillEqually
        backgroundColor = .white
        
        // 그림자 설정
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
    }
    
    // MARK: Layout
    
    private func setupLayout() { tabBarButtons.forEach { addArrangedSubview($0) } }
    
    // MARK: Bindings
    
    private func setupBindings() {
        Publishers
            .MergeMany(tabBarButtons.map { $0.selectedIndexPublisher })
            .sink { [weak self] in self?.selectedIndexSubject.send($0) }
            .store(in: &cancellables)
        
        selectedIndexSubject
            .sink { [weak self] index in
                self?.tabBarButtons.forEach { $0.selectedIndexBinder(index) }
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension TabBarView {
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        selectedIndexSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { TabBarView() }
