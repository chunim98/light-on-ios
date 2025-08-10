//
//  MapFilterTagItem.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

struct MapFilterTagItem {
    let tagType: MapFilterType
    var isSelected: Bool = false
    
    var title: String { tagType.rawValue }
    var style: MapFilterTagStyle { isSelected ? .selected : .normal }
    
    func updated(isSelected: Bool) -> MapFilterTagItem {
        MapFilterTagItem(
            tagType: self.tagType,
            isSelected: isSelected
        )
    }
}
