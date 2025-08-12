//
//  MapSearchBarButton.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import UIKit

import SnapKit

/// 서치바 모양을 모방한 레플리카 버튼
final class MapSearchBarButton: UIButton {
    
    // MARK: Components
    
    let searchBar = {
        let bar = MapSearchBar()
        bar.isUserInteractionEnabled = false
        return bar
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { configuration = .plain() }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
