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
    
    /// 드롭다운 상태
    @Published private var state = State(tableHidden: true, selectedItem: nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let tableContainer = DropdownTableContainerView()
    private let tableView = DropdownTableView<Item>()
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
        // 버튼 탭하면 테이블 뷰 표시 상태 갱신
        button.tapPublisher
            .sink { [weak self] in self?.state.tableHidden = false }
            .store(in: &cancellables)
        
        // 아이템 선택 시, 테이블 뷰 닫고 아이템 값 갱신
        tableView.selectedModelPublisher(dataSource: tableView.diffableDataSource)
            .sink { [weak self] in
                self?.state.tableHidden = true
                self?.state.selectedItem = $0
            }
            .store(in: &cancellables)
        
        // 상태에 따라서 UI 업데이트
        $state
            .sink { [weak self] in self?.updateUI(with: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension DropdownView {
    /// 상태에 따라서 UI 업데이트
    private func updateUI(with state: State) {
        button.setState(state.selectedItem.map { .filled($0.title) } ?? .idle)
        tableContainer.isHidden = state.tableHidden
    }
    
    /// 테이블 뷰 스냅샷 설정
    /// - 스냅샷 설정과 동시에 상태 초기화
    func setSnapshot(items: [Item]) {
        state = State(tableHidden: true, selectedItem: nil)
        tableView.setSnapshot(items: items)
        button.isEnabled = true
    }
    
    /// 배경 탭 시 테이블 뷰 닫기
    /// - 오버레이가 열려있을 때, 테이블 바깥 영역을 탭하면 닫히도록 처리
    func dismissTable(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tableContainer.superview) // 부모 뷰 기준 포인트 계산
        if !tableContainer.frame.contains(point),
           !tableContainer.isHidden {
            state.tableHidden = true
        }
    }
    
    /// 선택된 아이템을 갱신하고 상태를 퍼블리셔로 전달
    /// - Parameter item: 새로 선택된 아이템 (없으면 선택 해제)
    func selectItem(_ item: Item?) {
        state.selectedItem = item
    }
    
    /// 선택한 아이템 퍼블리셔
    var selectedItemPublisher: AnyPublisher<Item?, Never> {
        $state.map { $0.selectedItem }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
