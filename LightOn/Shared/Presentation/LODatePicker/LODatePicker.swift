//
//  LODatePicker.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit
import Combine

import SnapKit

final class LODatePicker: UIStackView {
    
    // MARK: Properties
    
    private let vm = LODatePickerVM()
    private var cancaellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let datePickerBodyContainer = UIStackView(inset: .init(edges: 18))
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.bold(22)
        label.textAlignment = .center
        label.textColor = .brand
        label.text = "날짜 선택" // temp
        return label
    }()
    private let pickerHeaderView = LODatePickerHeaderView()
    private let pickerBodyView = LODatePickerStyledBodyView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 14
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout

    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(pickerHeaderView)
        addArrangedSubview(datePickerBodyContainer)
        datePickerBodyContainer.addArrangedSubview(pickerBodyView)
        
        self.snp.makeConstraints { $0.width.equalTo(366); $0.height.equalTo(400)}
    }
    
    // MARK: Bindig
    
    private func setupBindings() {
        let input = LODatePickerVM.Input(
            previousButtonTapEvent: pickerHeaderView.previousButtonTapEventPublisher,
            nextButtonTapEvent: pickerHeaderView.nextButtonTapEventPublisher,
            currentPage: pickerBodyView.currentPagePublisher,
            dateRange: pickerBodyView.dateRangePublisher
        )
        let output = vm.transform(input)
        
        output.currentPage
            .sink { [weak self] in self?.pickerBodyView.currentPageBinder($0) }
            .store(in: &cancaellables)
        
        output.dateHeaderText
            .sink { [weak self] in self?.pickerHeaderView.dateHeaderTextBinder($0) }
            .store(in: &cancaellables)

        output.dateRange
            .sink { print($0.start?.toSimpleString(), $0.end?.toSimpleString()) }
            .store(in: &cancaellables)
    }
}

#Preview { LODatePicker() }
