//
//  GeocodingResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

struct GeocodingResDTO: Decodable {
    let status: String
    let meta: Meta
    let addresses: [Address]
    let errorMessage: String
    
    struct Meta: Decodable {
        let totalCount: Int
        let page: Int?
        let count: Int
    }
    
    struct Address: Decodable {
        let roadAddress: String
        let jibunAddress: String
        let englishAddress: String
        let addressElements: [AddressElement]
        let x: String
        let y: String
        let distance: Double
        
        struct AddressElement: Decodable {
            let types: [AddressType]
            let longName: String
            let shortName: String
            let code: String
        }
        
        enum AddressType: String, Decodable {
            case sido = "SIDO"                  // 시/도
            case sigugun = "SIGUGUN"            // 시/구/군
            case dongmyun = "DONGMYUN"          // 동/면
            case ri = "RI"                      // 리
            case roadName = "ROAD_NAME"         // 도로명
            case buildingNumber = "BUILDING_NUMBER" // 건물 번호
            case buildingName = "BUILDING_NAME" // 건물 이름
            case landNumber = "LAND_NUMBER"     // 번지
            case postalCode = "POSTAL_CODE"     // 우편번호
        }
    }
}

// MARK: Mapper

extension GeocodingResDTO.Address {
    func toDomain() -> GeocodingInfo {
        let lat = Double(y) ?? .zero
        let lng = Double(x) ?? .zero
        
        return GeocodingInfo.init(
            roadAddress: roadAddress,
            jibunAddress: jibunAddress,
            englishAddress: englishAddress,
            addressElements: addressElements.map { $0.toDomain() },
            coord: .init(latitude: lat, longitude: lng),
            distance: distance
        )
    }
}

extension GeocodingResDTO.Address.AddressElement {
    func toDomain() -> GeocodingInfo.AddressElement {
        GeocodingInfo.AddressElement.init(
            types: types.map { $0.toDomain() },
            longName: longName,
            shortName: shortName,
            code: code
        )
    }
}

extension GeocodingResDTO.Address.AddressType {
    func toDomain() -> GeocodingInfo.AddressType {
        switch self {
        case .sido:             .sido
        case .sigugun:          .sigugun
        case .dongmyun:         .dongmyun
        case .ri:               .ri
        case .roadName:         .roadName
        case .buildingNumber:   .buildingNumber
        case .buildingName:     .buildingName
        case .landNumber:       .landNumber
        case .postalCode:       .postalCode
        }
    }
}
