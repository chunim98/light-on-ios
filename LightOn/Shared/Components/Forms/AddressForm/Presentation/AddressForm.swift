//
//  AddressForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class AddressForm: TextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let dropdownHStack = {
        let sv = UIStackView(spacing: 12)
        sv.distribution = .fillEqually
        return sv
    }()
    
    let provinceDropdown = {
        let view = DropdownView<ProvinceCellItem>(placeholder: "도/시/군")
        view.setSnapshot(items: ProvinceCellItem.items)
        return view
    }()
    
    let cityDropdown = DropdownView<CityCellItem>(placeholder: "읍/면/동")
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        insertArrangedSubview(dropdownHStack, at: 1)
        dropdownHStack.addArrangedSubview(provinceDropdown)
        dropdownHStack.addArrangedSubview(cityDropdown)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 드롭다운 리스트 데이터 소스 설정
        provinceDropdown.selectedItemPublisher
            .sink { [weak self] in self?.setCityDropdown(item: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension AddressForm {
    /// 선택된 지역(province)에 해당하는 도시 목록을 불러와
    /// 드롭다운 리스트 데이터 소스로 설정
    private func setCityDropdown(item: ProvinceCellItem?) {
        let cities = item.flatMap { City.cities[$0.province] }
        let items = cities?.map { CityCellItem(city: $0) }
        guard let items else { return }
        cityDropdown.setSnapshot(items: items)
    }
    
    /// 지역코드로 드롭다운 값 바인딩
    func setRegionID(_ id: Int?) {
        for (province, cities) in City.cities {
            guard let city = cities.first(where: { $0.id == id }) else { continue }
            provinceDropdown.selectItem(.init(province: province))
            cityDropdown.selectItem(.init(city: city))
        }
    }
    
    /// 선택한 지역 아이디 퍼블리셔
    var regionIDPublisher: AnyPublisher<Int?, Never> {
        cityDropdown.selectedItemPublisher
            .map { $0?.city.id }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// 상세 주소 텍스트 퍼블리셔
    var detailAddressPublisher: AnyPublisher<String?, Never> {
        textPublisher
    }
}
