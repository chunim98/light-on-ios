//
//  SignUpFirstStepBaseForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit
import Combine

class SignUpFirstStepBaseForm: TextForm {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    let captionView = SignUpFirstStepCaptionView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() { addArrangedSubview(captionView) }
}

