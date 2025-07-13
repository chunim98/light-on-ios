//
//  DropdownView.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit


/// 사용 시 스냅샷 등록 및, 오버레이 레이아웃 메서드 호출 필수, 테이블 뷰 닫기도 바인딩 해줘야 함!
final class DropdownView<Item: DropdownCellItem>: UIStackView {
    
    struct State {
        var tableHidden: Bool
        var selectedItem: Item?
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State(tableHidden: true, selectedItem: nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let tableContainer = DropdownTableContainerView()
    let tableView = DropdownTableView<Item>()
    private let button: DropdownButton
    
    // MARK: Life Cycle
    
    init(placeholder: String) {
        self.button = .init(defaultTitle: placeholder)
        super.init(frame: .zero)
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() { addArrangedSubview(button) }
    
    /// 오버레이 레이아웃 구성 (부모 뷰에서 구성해야 함)
    func setupOverlayLayout(superView: UIView) {
        superView.addSubview(tableContainer)
        tableContainer.addArrangedSubview(tableView)
        
        tableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(button)
            $0.height.equalTo(329)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 버튼 탭, 테이블 뷰 열기
        button.tapPublisher
            .sink { [weak self] in self?.state.tableHidden = false }
            .store(in: &cancellables)
        
        // 아이템 선택, 테이블 뷰 닫고 아이템 값 갱신
        tableView.selectedModelPublisher(dataSource: tableView.diffableDataSource)
            .sink { [weak self] in
                self?.state.tableHidden = true
                self?.state.selectedItem = $0
            }
            .store(in: &cancellables)
        
        // 상태 바인딩
        $state.sink { [weak self] state in
            self?.tableContainer.isHidden = state.tableHidden
            self?.button.setState({
                guard let item = state.selectedItem else { return .idle }
                return .filled(item.title)
            }())
        }
        .store(in: &cancellables)
    }
    
    // MARK: Public Configuration
    
    /// 테이블 뷰 닫기
    func dismiss(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tableContainer.superview)  // 부모 뷰 기준 포인트 계산
        if !tableContainer.isHidden, !tableContainer.frame.contains(point) {
            state.tableHidden = true    // 오버레이가 열려있고, 배경을 탭하면 닫기
        }
    }
}

// MARK: Binders & Publishers

extension DropdownView {
    /// 선택한 아이템 퍼블리셔
    var selectedItemPublisher: AnyPublisher<Item?, Never> {
        $state.map { $0.selectedItem }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
