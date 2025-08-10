//
//  GeoPerformanceRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Combine
import CoreLocation

import Alamofire

protocol GeoPerformanceRepo {
    /// 좌표와 반경으로 공연맵 조회
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double
    ) -> AnyPublisher<[GeoPerformanceInfo], Never>
    
    /// 좌표와 반경, 필터로 공연맵 조회
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double,
        type: MapFilterType
    ) -> AnyPublisher<[GeoPerformanceInfo], Never>
}

// MARK: Default

final class DefaultGeoPerformanceRepo: GeoPerformanceRepo {
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double
    ) -> AnyPublisher<[GeoPerformanceInfo], Never> {
        Future { proimse in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/nearby",
                method: .get,
                parameters: [
                    "latitude": coord.latitude,
                    "longitude": coord.longitude,
                    "radius": radius
                ]
            )
            .decodeResponse(decodeType: GeoPerformanceListResDTO.self) {
                print("[\(type(of: self))] 전체 공연맵 조회 완료")
                proimse(.success($0.performanceMapList.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double,
        type: MapFilterType
    ) -> AnyPublisher<[GeoPerformanceInfo], Never> {
        Future { proimse in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/highlight",
                method: .get,
                parameters: [
                    "latitude": coord.latitude,
                    "longitude": coord.longitude,
                    "radius": radius,
                    "type": MapFilterTypeReqDTO(from: type).rawValue
                ]
            )
            .decodeResponse(decodeType: GeoPerformanceListResDTO.self) {
                print("[\(Swift.type(of: self))] 필터 공연맵 조회 완료")
                proimse(.success($0.performanceMapList.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
