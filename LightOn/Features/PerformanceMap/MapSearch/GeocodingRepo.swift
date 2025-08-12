//
//  GeocodingRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import Combine

import Alamofire

protocol GeocodingRepo {
    /// 주소로 지오코딩 요청(지명 -> 좌표)
    func getGeocodingInfo(name: String) -> AnyPublisher<[GeocodingInfo], Never>
}

// MARK: Default

final class DefaultGeocodingRepo: GeocodingRepo {
    func getGeocodingInfo(name: String) -> AnyPublisher<[GeocodingInfo], Never> {
        Future { promise in
            
            APIClient.plain.request(
                "https://maps.apigw.ntruss.com/map-geocode/v2" + "/geocode",
                method: .get,
                parameters: ["query": name],
                headers: [
                    "x-ncp-apigw-api-key-id": APIConstants.naverMapClientID,
                    "x-ncp-apigw-api-key": APIConstants.naverMapClientSecret,
                    "Accept": "application/json"
                ]
            )
            .decodeAnyResponse(decodeType: GeocodingResDTO.self) {
                print("[\(type(of: self))] 지오코딩 완료")
                promise(.success($0.addresses.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

