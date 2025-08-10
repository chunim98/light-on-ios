//
//  MapFilterTagStyle.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

import UIKit

struct MapFilterTagStyle {
    let foregroundColor: UIColor
    let backgroundColor: UIColor
    let strokeColor: UIColor
        
    static var selected: MapFilterTagStyle {
        MapFilterTagStyle(
            foregroundColor: .white,
            backgroundColor: .brand,
            strokeColor: .clear
        )
    }
    
    static var normal: MapFilterTagStyle {
        MapFilterTagStyle(
            foregroundColor: .brand,
            backgroundColor: .white,
            strokeColor: .brand
        )
    }
}
