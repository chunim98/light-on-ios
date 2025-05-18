//
//  LoginFormView.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

final class LoginFormView: LOFormView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    
    override init(isSecureTextEntry: Bool = false) {
        super.init()
        setBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Bindings
    
    private func setBindings() {
        let editingBegin = editingBeginPublisher.map { _ in UIColor.brand }
        let editingEnd = editingEndPublisher.map { _ in UIColor.infoText }
        
        Publishers.Merge(editingBegin, editingEnd)
            .sink { [weak self] in
                self?.setTitleColor($0)
                self?.setBorderColor($0)
            }
            .store(in: &cancellables)
    }
}
