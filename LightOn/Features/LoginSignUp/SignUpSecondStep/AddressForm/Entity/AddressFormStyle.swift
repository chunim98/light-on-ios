//
//  AddressFormStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//

struct AddressFormStyle {
    let provinceTableHidden: Bool
    let cityTableHidden: Bool
    
    static var allClosed: AddressFormStyle {
        AddressFormStyle(
            provinceTableHidden: true,
            cityTableHidden: true
        )
    }
    
    static var provinceOpen: AddressFormStyle {
        AddressFormStyle(
            provinceTableHidden: false,
            cityTableHidden: true
        )
    }
    
    static var cityOpen: AddressFormStyle {
        AddressFormStyle(
            provinceTableHidden: true,
            cityTableHidden: false
        )
    }
}
