//
//  GenreForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import UIKit
import Combine

final class GenreForm: BaseForm {
    
    // MARK: Components
    
    let dropdown = {
        let view = DropdownView<GenreCellItem>(placeholder: "장르를 선택해 주세요")
        view.tableView.setSnapshot(items: GenreCellItem.genres)
        return view
    }()
    
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
    
    private func setupDefaults() { titleLabel.config.text = "공연 장르" }
    
    // MARK: Layout
    
    private func setupLayout() { addArrangedSubview(dropdown) }
}

// MARK: Binders & Publishers

extension GenreForm {
    /// 선택한 장르 아이디 퍼블리셔
    var genrePublisher: AnyPublisher<[String], Never> {
        dropdown.selectedItemPublisher.map { $0.map { [$0.title] } ?? [] }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
