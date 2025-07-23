//
//  AudienceCountPickerView.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//


import UIKit
import Combine

import SnapKit

final class AudienceCountPickerView: UIView {
    
    // MARK: Properties
    
    private let numbers = Array(1...99)
    
    // MARK: Outputs
    
    private let selectedNumberSubject = CurrentValueSubject<Int, Never>(1)  // 기본값
    
    // MARK: Components
    
    private let pickerView = UIPickerView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pickerView.subviews[safe: 1]?.isHidden = true   // 피커뷰 중앙 막대 숨김
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}

// MARK: Binders & Publishers

extension AudienceCountPickerView {
    /// 선택한 관객 수 퍼블리셔
    var countPublisher: AnyPublisher<Int, Never> {
        selectedNumberSubject.eraseToAnyPublisher()
    }
}

// MARK: - UIPickerViewDataSource

extension AudienceCountPickerView: UIPickerViewDataSource {
    /// 피커 뷰에 몇 개의 컴포넌트(열, column)가 있는지 반환
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// 각 컴포넌트(열)에 몇 개의 행(row)이 있는지 반환
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        numbers.count
    }
    
    /// 열 높이 반환
    func pickerView(
        _ pickerView: UIPickerView,
        rowHeightForComponent component: Int
    ) -> CGFloat {
        return 28
    }
}

// MARK: - UIPickerViewDelegate

extension AudienceCountPickerView: UIPickerViewDelegate {
    /// 각 행에 보여줄 텍스트를 반환
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(22)
        config.foregroundColor = .black
        config.alignment = .center
        config.text = "\(numbers[row])명"
        return LOLabel(config: config)
    }
    
    /// 특정 행을 선택했을 때 호출
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        selectedNumberSubject.send(numbers[row])
    }
}

// MARK: - Preview

#Preview { AudienceCountPickerView() }
