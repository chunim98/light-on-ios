//
//  UploadBaseForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit

class UploadBaseForm: TextForm {
    
    // MARK: Components
    
    let button = {
        let button = LOButton(style: .borderedTinted, width: 109)
        button.setTitle("파일 업로드", .pretendard.semiBold(16))
        return button
    }()
    
    private let captionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .infoText
        config.text = "* 10mb 이하 PDF, png, jpeg, jpg, 파일만 업로드 가능합니다."
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(captionLabel)
        textFieldHStack.addArrangedSubview(LOSpacer(12))
        textFieldHStack.addArrangedSubview(button)
    }
}
