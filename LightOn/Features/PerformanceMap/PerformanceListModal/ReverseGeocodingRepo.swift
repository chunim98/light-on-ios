//
//  ReverseGeocodingRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Combine
import CoreLocation

import Alamofire

protocol ReverseGeocodingRepo {
    /// 좌표값으로 주소 조회
    func getDongName(coord: CLLocationCoordinate2D) -> AnyPublisher<String?, Never>
}

// MARK: - Default

final class DefaultReverseGeocodingRepo: ReverseGeocodingRepo {
    func getDongName(coord: CLLocationCoordinate2D) -> AnyPublisher<String?, Never> {
        Future { promise in
            
            APIClient.plain.request(
                "https://maps.apigw.ntruss.com/map-reversegeocode/v2" + "/gc",
                method: .get,
                parameters: [
                    "coords": "\(coord.longitude),\(coord.latitude)",
                    "orders": "admcode",    // 행정동 단위
                    "output": "json"        // json 응답
                ],
                headers: [
                    "x-ncp-apigw-api-key-id": APIConstants.naverMapClientID,
                    "x-ncp-apigw-api-key": APIConstants.naverMapClientSecret
                ]
            )
            .decodeAnyResponse(decodeType: ReverseGeocodingResDTO.self) {
                print("[\(type(of: self))] 리버스 지오코딩 완료")
                promise(.success($0.getDongName()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

