//
//  GenreTagItem.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//


struct GenreTagItem {
    let tag: Int
    let title: String
    let isSelected: Bool
    let style: GenreTagStyle
    
    init(
        tag: Int,
        title: String,
        isSelected: Bool = false
    ) {
        self.tag = tag
        self.title = title
        self.isSelected = isSelected
        self.style = isSelected ? .selected : .normal
    }
    
    func updated(
        tag: Int? = nil,
        title: String? = nil,
        isSelected: Bool? = nil
    ) -> GenreTagItem {
        GenreTagItem(
            tag: tag ?? self.tag,
            title: title ?? self.title,
            isSelected: isSelected ?? self.isSelected
        )
    }
    
    static let mocks: [GenreTagItem] = [
        .init(tag: 0, title: "전체", isSelected: true),
        .init(tag: 1, title: "어쿠스틱", isSelected: false),
        .init(tag: 2, title: "재즈", isSelected: false),
        .init(tag: 3, title: "클래식", isSelected: false),
        .init(tag: 4, title: "록", isSelected: false),
        .init(tag: 5, title: "팝", isSelected: false),
        .init(tag: 6, title: "인디", isSelected: false),
        .init(tag: 7, title: "힙합", isSelected: false)
    ]
}
