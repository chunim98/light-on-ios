//
//  ScheduleFormVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import UIKit
import Combine

import SnapKit

final class ScheduleFormVC: UIViewController {
    
    // MARK: Components
    
    private let baseForm = {
        let form = BaseForm()
        form.titleLabel.config.text = "공연 일시"
        return form
    }()
    
    let datePickerFormCompVC = DatePickerFormComponentVC()
    let timePickerFormCompVC = TimePickerFormComponentVC()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(datePickerFormCompVC)
        addChild(timePickerFormCompVC)
        
        view.addSubview(baseForm)
        baseForm.addArrangedSubview(datePickerFormCompVC.view)
        baseForm.addArrangedSubview(timePickerFormCompVC.view)
        
        baseForm.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        datePickerFormCompVC.didMove(toParent: self)
        timePickerFormCompVC.didMove(toParent: self)
    }
}
