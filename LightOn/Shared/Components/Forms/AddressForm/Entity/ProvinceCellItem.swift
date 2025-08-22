//
//  ProvinceCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 8/22/25.
//

struct ProvinceCellItem: DropdownCellItem {
    let province: Province
    var title: String { province.rawValue }

    /// 사전 정의된 광역 단위 지역 이름들
    static let items: [ProvinceCellItem] = Province.allCases
        .map { .init(province: $0) }
}
