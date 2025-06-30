//
//  AddressFormState.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

struct AddressFormState {
    let provinceSelection: Province?
    let citySelection: City?
    let style: AddressFormStyle
    
    func updated(
        provinceSelection: Province?? = nil,
        citySelection: City?? = nil,
        style: AddressFormStyle? = nil
    ) -> AddressFormState {
        return AddressFormState(
            provinceSelection: provinceSelection ?? self.provinceSelection,
            citySelection: citySelection ?? self.citySelection,
            style: style ?? self.style
        )
    }
}
