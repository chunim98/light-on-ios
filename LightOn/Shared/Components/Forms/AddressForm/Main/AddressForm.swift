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
    
    let provinceDropdown = ProvinceDropdownView()
    let cityDropdown = CityDropdownView()
    
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
        provinceDropdown.provincePublisher
            .sink { [weak self] in self?.cityDropdown.bindProvince($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension AddressForm {
    /// 선택한 지역 아이디 퍼블리셔
    var regionIDPublisher: AnyPublisher<Int?, Never> {
        cityDropdown.regionIDPublisher
    }
    
    /// 상세 주소 텍스트 퍼블리셔
    var detailAddressPublisher: AnyPublisher<String?, Never> {
        textPublisher // 이름만 다르게 랩핑
    }
}

// MARK: - Preview

#Preview { RegisterPerformanceVC() }

