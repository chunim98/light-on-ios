//
//  ProvinceDropdownView.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class ProvinceDropdownView: UIStackView {
    
    // MARK: Properties
    
    private let vm = ProvinceDropdownVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Inputs
    
    private let dismissTableEventSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Outputs
    
    /// 선택한 광역단위 외부 방출 서브젝트
    private let selectedProvinceSubject = PassthroughSubject<Province?, Never>()
    
    // MARK: Components
    
    let button = DropdownButton(defaultTitle: "도/시/군")
    let tableContainer = DropdownTableContainerView()
    let tableView = ProvinceTableView()
    
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
        tableView.setSnapshot(items: Province.allCases)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(button)
    }
    
    /// 오버레이 레이아웃 구성 (부모 뷰에서 구성해야 함)
    func setupOverlayLayout(superView: UIView) {
        superView.addSubview(tableContainer)
        tableContainer.addArrangedSubview(tableView)
        
        tableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self)
            $0.height.equalTo(329)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedItem = tableView.selectedModelPublisher(
            dataSource: tableView.diffableDataSource
        )
        
        let input = ProvinceDropdownVM.Input(
            buttonTap: button.tapPublisher,
            dismissTableEvent: dismissTableEventSubject.eraseToAnyPublisher(),
            selectedProvince: selectedItem
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in
                self?.selectedProvinceSubject.send($0.selectedProvince)
                self?.bindState($0)
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ProvinceDropdownView {
    /// 상태 바인딩
    private func bindState(_ state: ProvinceDropdownState) {
        tableContainer.isHidden = state.tableHidden
        button.setState({
            guard let item = state.selectedProvince else { return .idle }
            return .filled(item.rawValue)
        }())
    }
    
    /// 테이블 뷰 닫기 바인딩
    func bindDismissTable(_ gesture: UITapGestureRecognizer) {
        // 부모 뷰 기준 포인트 계산
        let point = gesture.location(in: tableContainer.superview)
        
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        if !tableContainer.isHidden, !tableContainer.frame.contains(point) {
            dismissTableEventSubject.send(())
        }
    }
    
    /// 선택한 광역단위 퍼블리셔
    var provincePublisher: AnyPublisher<Province?, Never> {
        selectedProvinceSubject.removeDuplicates().eraseToAnyPublisher()
    }
}
