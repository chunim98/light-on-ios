//
//  AddressForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/27/25.
//

import UIKit
import Combine

import CombineCocoa

final class AddressForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Components
    
    private let mainHStack = {
        let sv = UIStackView(spacing: 12)
        sv.distribution = .fillEqually
        return sv
    }()
    
    let cityButton = {
        let button = AddressFormButton()
        button.titleConfig.text = "도/시/군"
        return button
    }()
    
    let townButton = {
        let button = AddressFormButton()
        button.titleConfig.text = "읍/면/동"
        return button
    }()
        
    let cityTableContainer = {
        let container = AddressTableViewContainer()
        container.tableView.setSnapshot(items: [
            "도/시/군",
            "서울특별시", "부산광역시", "대구광역시", "인천광역시",
            "광주광역시", "대전광역시", "울산광역시", "세종특별자치시",
            "경기도", "강원특별자치도", "충청북도", "충청남도",
            "전라북도", "전라남도", "경상북도", "경상남도",
            "제주특별자치도"
        ])
        container.isHidden = true
        return container
    }()
    
    let townTableContainer = {
        let container = AddressTableViewContainer()
        container.tableView.setSnapshot(items: [
            "읍/면/동",
            "서울특별시", "부산광역시", "대구광역시", "인천광역시",
            "광주광역시", "대전광역시", "울산광역시", "세종특별자치시",
            "경기도", "강원특별자치도", "충청북도", "충청남도",
            "전라북도", "전라남도", "경상북도", "경상남도",
            "제주특별자치도"
        ])
        container.isHidden = true
        return container
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { titleLabel.config.text = "선호 지역" }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(mainHStack)
        mainHStack.addArrangedSubview(cityButton)
        mainHStack.addArrangedSubview(townButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        cityButton.tapPublisher
            .sink { [weak self] in self?.cityTableContainer.isHidden = false }
            .store(in: &cancellables)
        
        townButton.tapPublisher
            .sink { [weak self] in self?.townTableContainer.isHidden = false }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview {
    AddressForm()
}
