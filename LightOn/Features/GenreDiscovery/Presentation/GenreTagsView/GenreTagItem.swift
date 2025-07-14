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
    var style: GenreTagStyle { isSelected ? .selected : .normal }
    
    init(
        tag: Int,
        title: String,
        isSelected: Bool
    ) {
        self.tag = tag
        self.title = title
        self.isSelected = isSelected
    }
    
    func updated(isSelected: Bool) -> GenreTagItem {
        GenreTagItem(
            tag: self.tag,
            title: self.title,
            isSelected: isSelected
        )
    }
}
