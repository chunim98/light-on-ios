//
//  MapSearchView.swift
//  LightOn
//
//  Created by 신정욱 on 7/27/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MapSearchView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    
    // MARK: Life Cycle
    

    // MARK: Defaults
    
    private func setupDefaults() {
        backgroundColor = .white
        axis = .vertical
        isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(LOSpacer(84))  // 서치바 공간 고려
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
    }
}
