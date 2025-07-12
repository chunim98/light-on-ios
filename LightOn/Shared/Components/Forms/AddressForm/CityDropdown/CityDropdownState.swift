//
//  CityDropdownState.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

struct CityDropdownState {
    let tableHidden: Bool
    let selectedProvince: Province?
    let selectedCity: City?
    
    func updated(
        tableHidden: Bool? = nil,
        selectedProvince: Province?? = nil,
        selectedCity: City?? = nil
    ) -> CityDropdownState {
        CityDropdownState(
            tableHidden: tableHidden ?? self.tableHidden,
            selectedProvince: selectedProvince ?? self.selectedProvince,
            selectedCity: selectedCity ?? self.selectedCity
        )
    }
}
