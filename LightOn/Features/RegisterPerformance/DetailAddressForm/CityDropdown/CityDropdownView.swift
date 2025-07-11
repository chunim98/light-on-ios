//
//  CityDropdownView.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//


import UIKit
import Combine

import CombineCocoa
import SnapKit

final class CityDropdownView: UIStackView {
    
    // MARK: Properties
    
    private let vm = CityDropdownVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Inputs
    
    private let dismissTableEventSubject = PassthroughSubject<Void, Never>()
    private let provinceSubject = PassthroughSubject<Province?, Never>()
    
    // MARK: Outputs
    
    /// 선택한 지역단위 외부 방출 서브젝트
    private let selectedCitySubject = PassthroughSubject<City?, Never>()
    
    // MARK: Components
    
    let button = DropdownButton(defaultTitle: "읍/면/동")
    let tableContainer = TableContainerView()
    let tableView = CityTableView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let selectedCity = tableView.selectedModelPublisher(
            dataSource: tableView.diffableDataSource
        )
        
        let input = CityDropdownVM.Input(
            buttonTap: button.tapPublisher,
            dismissTableEvent: dismissTableEventSubject.eraseToAnyPublisher(),
            selectedProvince: provinceSubject.eraseToAnyPublisher(),
            selectedCity: selectedCity
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in
                self?.selectedCitySubject.send($0.selectedCity)
                self?.bindState($0)
            }
            .store(in: &cancellables)
        
        output.cities
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension CityDropdownView {
    /// 상태 바인딩
    private func bindState(_ state: CityDropdownState) {
        tableContainer.isHidden = state.tableHidden
        button.isEnabled = state.selectedProvince != nil
        button.setState({
            guard let city = state.selectedCity else { return .idle }
            return .filled(city.name)
        }())
    }
    
    /// 테이블 뷰 닫기 바인딩
    func bindDismissTable(gesture: UITapGestureRecognizer) {
        // 부모 뷰 기준 포인트 계산
        let point = gesture.location(in: tableContainer.superview)
        
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        if !tableContainer.isHidden, !tableContainer.frame.contains(point) {
            dismissTableEventSubject.send(())
        }
    }
    
    /// 선택한 광역단위 바인딩 (테이블 데이터 바인딩 목적)
    func bindProvince(_ province: Province?) {
        provinceSubject.send(province)
    }
    
    /// 선택한 지역 아이디 퍼블리셔
    var regionIDPublisher: AnyPublisher<Int?, Never> {
        selectedCitySubject
            .removeDuplicates()
            .map { $0?.id }
            .eraseToAnyPublisher()
    }
}
