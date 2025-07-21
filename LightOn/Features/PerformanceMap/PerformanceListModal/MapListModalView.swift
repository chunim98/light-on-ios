//
//  MapListModalView.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MapListModalView: MapGrabberModalView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(19)
        config.foregroundColor = .loBlack
        config.text = "위치 조회 중.."
        return LOPaddingLabel(
            configuration: config,
            padding: .init(top: 12, bottom: 8)
        )
    }()
    
    let mapTableView = MapTableView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addArrangedSubview(mapTableView)
        grabberHeaderVStack.addArrangedSubview(titleLabel)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: Binders & Publishers

extension MapListModalView {
    /// 타이틀 텍스트 바인딩
    func bindTitle(_ title: String?) {
        titleLabel.config.text = title ?? "위치 조회 중.."
    }
}
