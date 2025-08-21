//
//  TimePickerView.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//


import UIKit
import Combine

import SnapKit

final class TimePickerView: UIView {
    
    // MARK: Properties
    
    private let amPM = ["오전", "오후"]
    private let hours = Array(1...12)
    private let minutes = Array(stride(from: 0, to: 60, by: 10))
    
    // MARK: Outputs
    
    private let amPMSubject = CurrentValueSubject<String, Never>("오전")  // 기본값
    private let hoursSubject = CurrentValueSubject<Int, Never>(1)       // 기본값
    private let minutesSubject = CurrentValueSubject<Int, Never>(0)     // 기본값
    
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
        pickerView.subviews[safe: 1]?.isHidden = true // 피커뷰 중앙 막대 숨김
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

extension TimePickerView {
    /// 선택한 시간 갱신
    func updateTime(_ time: String?) {
        // 문자열을 ":" 기준으로 분리하고 시(hour)와 분(minute) 추출
        guard
            let components = time?.split(separator: ":"),
            components.count >= 2,
            let hour24 = Int(components[0]),
            let minute = Int(components[1])
        else { return }
        
        // 24시간제를 오전/오후 + 12시간제로 변환
        let ampmValue = hour24 >= 12 ? "오후" : "오전"
        let hour12 = (hour24 % 12 == 0) ? 12 : (hour24 % 12)
        
        // 변환된 값에 맞는 배열 인덱스 찾기
        guard let amPMIndex = amPM.firstIndex(of: ampmValue),
              let hourIndex = hours.firstIndex(of: hour12),
              let minuteIndex = minutes.firstIndex(of: minute)
        else { return }
        
        // 피커뷰를 해당 인덱스 위치로 이동
        pickerView.selectRow(amPMIndex, inComponent: 0, animated: false)
        pickerView.selectRow(hourIndex, inComponent: 1, animated: false)
        pickerView.selectRow(minuteIndex, inComponent: 2, animated: false)
        
        // 선택된 값들을 Subject로 발행해서 상태 갱신
        amPMSubject.send(ampmValue)
        hoursSubject.send(hour12)
        minutesSubject.send(minute)
    }
    
    /// 선택한 시간 퍼블리셔
    var timePublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest3(
            amPMSubject.eraseToAnyPublisher(),
            hoursSubject.eraseToAnyPublisher(),
            minutesSubject.eraseToAnyPublisher()
        )
        .compactMap { amPM, hour, minute in
            let hour24 = (amPM == "오후") ? (hour%12) + 12 : (hour%12)    // 24시간제 변경
            return String(format: "%02d:%02d", hour24, minute)          // 문자열 포멧
        }
        .eraseToAnyPublisher()
    }
}



// MARK: - UIPickerViewDataSource

extension TimePickerView: UIPickerViewDataSource {
    /// 피커 뷰에 몇 개의 컴포넌트(열, column)가 있는지 반환
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    /// 각 컴포넌트(열)에 몇 개의 행(row)이 있는지 반환
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        switch component {
        case 0: amPM.count
        case 1: hours.count
        case 2: minutes.count
        default: 0
        }
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

extension TimePickerView: UIPickerViewDelegate {
    /// 각 행에 보여줄 텍스트를 반환
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(20)
        config.foregroundColor = .black
        config.alignment = .center
        config.lineHeight = 20
        
        switch component {
        case 0: config.text = amPM[row]
        case 1: config.text = String(format: "%02d시", hours[row])
        case 2: config.text = String(format: "%02d분", minutes[row])
        default: break
        }
        
        return LOLabel(config: config)
    }
    
    /// 특정 행을 선택했을 때 호출
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        switch component {
        case 0: amPMSubject.send(amPM[row])
        case 1: hoursSubject.send(hours[row])
        case 2: minutesSubject.send(minutes[row])
        default: break
        }
    }
}

// MARK: - Preview

#Preview { TimePickerView() }
