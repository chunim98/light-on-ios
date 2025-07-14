//
//  DocumentUploadForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class DocumentUploadForm: UploadBaseForm {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연 진행 증빙자료"
        textField.setPlaceHolder("파일을 업로드 해주세요")
    }
    
    // MARK: Layout
    
    private func setupLayout() {}
    
    // MARK: Bindings
    
    private func setupBindings() {}
    
    // MARK: Public Configuration
    
    // MARK: Binders & Publishers

}

// MARK: - Preview

#Preview { DocumentUploadForm() }

