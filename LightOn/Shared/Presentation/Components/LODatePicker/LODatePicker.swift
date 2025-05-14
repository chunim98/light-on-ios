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
    private let pickerBodyView = LOStyledDatePickerBodyView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 14
        setAutoLayout()
        
        pickerBodyView.currentPagePublisher
            .sink {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
                formatter.dateFormat = "yyyy년 M월"

                let formattedDate = formatter.string(from: $0)
                self.pickerHeaderView.dateHeaderTextBinder(formattedDate)
            }
            .store(in: &cancaellables)
        
        pickerBodyView.dateRangePublisher
            .sink { dateRange in
                guard let dateRange else { print("닐이네요"); return }
                print(dateRange.start.toSimpleString(), dateRange.end.toSimpleString())
            }
            .store(in: &cancaellables)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout

    private func setAutoLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(pickerHeaderView)
        addArrangedSubview(datePickerBodyContainer)
        datePickerBodyContainer.addArrangedSubview(pickerBodyView)
        
        self.snp.makeConstraints { $0.width.equalTo(366); $0.height.equalTo(400)}
    }
}

#Preview { LODatePicker() }
