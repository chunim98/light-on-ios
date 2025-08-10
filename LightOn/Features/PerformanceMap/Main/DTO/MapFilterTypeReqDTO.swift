//
//  MapFilterTypeReqDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

enum MapFilterTypeReqDTO: String, Encodable {
    case recommend = "RECOMMENDED"
    case recent = "RECENT"
    case closingSoon = "CLOSING_SOON"
    case myGenre = "MY_GENRE"
    
    init(from domain: MapFilterType) {
        switch domain {
        case .recommend:    self = .recommend
        case .recent:       self = .recent
        case .closingSoon:  self = .closingSoon
        case .myGenre:      self = .myGenre
        }
    }
}
