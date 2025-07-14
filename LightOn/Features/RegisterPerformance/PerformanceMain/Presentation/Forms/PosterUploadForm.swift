//
//  PosterUploadForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PosterUploadForm: UploadBaseForm {
    
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
        titleLabel.config.text = "공연 홍보 이미지"
        textField.setPlaceHolder("공연 포스터 및 사진 업로드")
    }
    
    // MARK: Layout
    
    private func setupLayout() {}
    
    // MARK: Bindings
    
    private func setupBindings() {}
    
    // MARK: Public Configuration
    
    // MARK: Binders & Publishers

}

// MARK: - Preview

#Preview { PosterUploadForm() }
