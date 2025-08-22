//
//  CityCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 8/22/25.
//

struct CityCellItem: DropdownCellItem {
    let city: City
    var title: String { city.name }
}
