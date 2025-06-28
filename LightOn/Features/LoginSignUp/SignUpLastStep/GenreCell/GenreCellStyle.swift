//
//  GenreCellStyle.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

struct GenreCellStyle {
    let overlayColor: CGColor
    let genreTextColor: UIColor
    let strokeColor: CGColor
    
    static var selected: GenreCellStyle {
        .init(
            overlayColor: UIColor.white.withAlphaComponent(0.6).cgColor,
            genreTextColor: .pressed,
            strokeColor: UIColor.pressed.cgColor
        )
    }
    
    static var normal: GenreCellStyle {
        .init(
            overlayColor: UIColor.black.withAlphaComponent(0.5).cgColor,
            genreTextColor: .white,
            strokeColor: UIColor.clear.cgColor
        )
    }
}
