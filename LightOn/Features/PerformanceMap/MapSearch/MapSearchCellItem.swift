//
//  MapSearchCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import CoreLocation

struct MapSearchCellItem: Hashable {
    let id = UUID().uuidString
    let name: String
    let description: String
    let coord: CLLocationCoordinate2D
    
    static func == (
        lhs: MapSearchCellItem,
        rhs: MapSearchCellItem
    ) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
