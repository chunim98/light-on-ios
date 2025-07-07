//
//  AddressForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/27/25.
//

import UIKit
import Combine

import CombineCocoa

class AddressForm: BaseForm {
    
    // MARK: Properties
    
    private let vm = AddressFormVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let regionIDSubject = PassthroughSubject<Int?, Never>()
    
    // MARK: Components
    
    private let mainHStack = {
        let sv = UIStackView(spacing: 12)
        sv.distribution = .fillEqually
        return sv
    }()
    
    let provinceTableContainer = {
        let sv = UIStackView()
        sv.layer.shadowOffset  = .init(width: 0, height: 5)
        sv.layer.shadowColor = UIColor.black.cgColor
        sv.layer.shadowOpacity = 0.1
        sv.layer.shadowRadius  = 15
        return sv
    }()
    
    let cityTableContainer = {
        let sv = UIStackView()
        sv.layer.shadowOffset  = .init(width: 0, height: 5)
        sv.layer.shadowColor = UIColor.black.cgColor
        sv.layer.shadowOpacity = 0.1
        sv.layer.shadowRadius  = 15
        return sv
    }()
    
    let provinceButton = AddressFormButton()
    let cityButton = AddressFormButton()
    
    let provinceTableView = ProvinceTableView()
    let cityTableView = CityTableView()
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // shadowPath로 그림자 렌더링 성능 개선
        provinceTableContainer.layer.shadowPath = UIBezierPath(
            rect: provinceTableContainer.bounds
        ).cgPath
        cityTableContainer.layer.shadowPath = UIBezierPath(
            rect: cityTableContainer.bounds
        ).cgPath
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { titleLabel.config.text = "선호 지역" }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(mainHStack)
        mainHStack.addArrangedSubview(provinceButton)
        mainHStack.addArrangedSubview(cityButton)
        
        provinceTableContainer.addArrangedSubview(provinceTableView)
        cityTableContainer.addArrangedSubview(cityTableView)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedProvince = provinceTableView.selectedModelPublisher(
            dataSource: provinceTableView.diffableDataSource
        )
        
        let selectedCity = cityTableView.selectedModelPublisher(
            dataSource: cityTableView.diffableDataSource
        )
        
        let input = AddressFormVM.Input(
            provinceTap: provinceButton.tapPublisher,
            cityTap: cityButton.tapPublisher,
            selectedProvince: selectedProvince,
            selectedCity: selectedCity
        )
        
        let output = vm.transform(input)
        
        output.provinces
            .sink { [weak self] in self?.provinceTableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.cities
            .sink { [weak self] in self?.cityTableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.state
            .sink { [weak self] in self?.bindAddressFormState($0) }
            .store(in: &cancellables)
        
        output.regionID
            .sink { [weak self] in self?.regionIDSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension AddressForm {
    /// 주소 폼 상태 바인딩
    private func bindAddressFormState(_ state: AddressFormState) {
        // 스타일
        provinceTableContainer.isHidden = state.style.provinceTableHidden
        cityTableContainer.isHidden = state.style.cityTableHidden
        // 값
        provinceButton.setTitle(
            selected: state.provinceSelection?.rawValue,
            normal: "도/시/군"
        )
        cityButton.setTitle(
            selected: state.citySelection?.name,
            normal: "읍/면/동"
        )
    }
    
    /// 선택한 지역 아이디
    var regionIDPublisher: AnyPublisher<Int?, Never> {
        regionIDSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    AddressForm()
}
