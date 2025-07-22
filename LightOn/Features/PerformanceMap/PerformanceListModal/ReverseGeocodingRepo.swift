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
            
            let baseURL = "https://maps.apigw.ntruss.com/map-reversegeocode/v2"
            let endPoint = "/gc"
            
            let parameters = [
                "coords": "\(coord.longitude),\(coord.latitude)",
                "orders": "admcode",    // 행정동 단위
                "output": "json"        // json 응답
            ]
            
            let headers: HTTPHeaders = [
                "x-ncp-apigw-api-key-id": APIConstants.naverMapClientID,
                "x-ncp-apigw-api-key": APIConstants.naverMapClientSecret
            ]
            
            // 네트워크 통신 시작
            AF.request(
                baseURL + endPoint,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,  // URL로 쿼리
                headers: headers
            )
            .responseDecodable(
                of: ReverseGeocodingResDTO.self
            ) { response in
                switch response.result {
                case .success(let dto):
                    let statusCode = response.response?.statusCode ?? -1
                    
                    if (200..<300).contains(statusCode) {
                        print("리버스 지오코딩 완료")
                        promise(.success(dto.getDongName()))
                        
                    } else {
                        print("리버스 지오코딩 실패: error message", dto.status.message)
                        print("리버스 지오코딩 실패: error status", dto.status.code)
                    }
                    
                case .failure(let afError):
                    print("리버스 지오코딩 실패: AFError", afError)    // 어떤 에러인지 로그
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
}

