//
//  ProvinceDropdownState.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

struct ProvinceDropdownState {
    let tableHidden: Bool
    let selectedProvince: Province?
    
    func updated(
        tableHidden: Bool? = nil,
        selectedProvince: Province?? = nil
    ) -> ProvinceDropdownState {
        ProvinceDropdownState(
            tableHidden: tableHidden ?? self.tableHidden,
            selectedProvince: selectedProvince ?? self.selectedProvince
        )
    }
}
