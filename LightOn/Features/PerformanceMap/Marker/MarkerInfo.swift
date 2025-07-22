//
//  MarkerInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/17/25.
//

struct MarkerInfo: Equatable {
    let performaceID: Int
    let latitude: Double
    let longitude: Double
    
    
    static let mocks: [MarkerInfo] = [
        .init(performaceID: 0, latitude: 37.5080, longitude: 127.0630), // 삼성역
        .init(performaceID: 1, latitude: 37.5219, longitude: 127.0225), // 신사역
        .init(performaceID: 2, latitude: 37.5075, longitude: 127.0348), // 선릉역
        .init(performaceID: 3, latitude: 37.5043, longitude: 127.0537), // 청담동
        .init(performaceID: 4, latitude: 37.4934, longitude: 127.0665), // 대치동
        .init(performaceID: 5, latitude: 37.4838, longitude: 127.0327), // 교대역
        .init(performaceID: 6, latitude: 37.4948, longitude: 127.0551), // 잠실새내
        .init(performaceID: 7, latitude: 37.5241, longitude: 127.0286), // 압구정
        .init(performaceID: 8, latitude: 37.4782, longitude: 127.0407), // 서초동
        .init(performaceID: 9, latitude: 37.5023, longitude: 127.0459), // 논현역
        .init(performaceID: 10, latitude: 37.5152, longitude: 127.0571), // 잠원동
        .init(performaceID: 11, latitude: 37.4846, longitude: 127.0250), // 방배동
        .init(performaceID: 12, latitude: 37.4997, longitude: 127.0411), // 강남구청
        .init(performaceID: 13, latitude: 37.5175, longitude: 127.0413), // 신사동
        .init(performaceID: 14, latitude: 37.5020, longitude: 127.0570), // 삼성동
        .init(performaceID: 15, latitude: 37.4960, longitude: 127.0485), // 역삼동
        .init(performaceID: 16, latitude: 37.4851, longitude: 127.0584), // 송파동
        .init(performaceID: 17, latitude: 37.4789, longitude: 127.0461), // 서초구청
        .init(performaceID: 18, latitude: 37.5112, longitude: 127.0196), // 한남동
        .init(performaceID: 19, latitude: 37.4887, longitude: 127.0365)  // 양재역
    ]
}
