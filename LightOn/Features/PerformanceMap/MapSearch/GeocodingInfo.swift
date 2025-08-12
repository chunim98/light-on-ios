//
//  GeocodingInfo.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import CoreLocation

struct GeocodingInfo {
    let roadAddress: String
    let jibunAddress: String
    let englishAddress: String
    let addressElements: [AddressElement]
    let coord: CLLocationCoordinate2D
    let distance: Double
    
    struct AddressElement {
        let types: [AddressType]
        let longName: String
        let shortName: String
        let code: String
    }
    
    enum AddressType: String {
        case sido           // 시/도
        case sigugun        // 시/구/군
        case dongmyun       // 동/면
        case ri             // 리
        case roadName       // 도로명
        case buildingNumber // 건물 번호
        case buildingName   // 건물 이름
        case landNumber     // 번지
        case postalCode     // 우편번호
    }
}

// MARK: Mapper

extension GeocodingInfo {
    func toCellItem() -> MapSearchCellItem {
        MapSearchCellItem(
            name: roadAddress.components(separatedBy: " ").last ?? "알 수 없음",
            description: roadAddress,
            coord: coord
        )
    }
}
