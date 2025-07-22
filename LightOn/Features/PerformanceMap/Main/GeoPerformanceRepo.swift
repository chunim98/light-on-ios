//
//  GeoPerformanceRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Combine
import CoreLocation

protocol GeoPerformanceRepo {
    /// 좌표와 반경으로 공연맵 조회
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double
    ) -> AnyPublisher<[GeoPerformanceInfo], Never>
}

// MARK: - Default

final class DefaultGeoPerformanceRepo: GeoPerformanceRepo {
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double
    ) -> AnyPublisher<[GeoPerformanceInfo], Never> {
        Future { proimse in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/performances/nearby",
                parameters: [
                    "latitude": coord.latitude,
                    "longitude": coord.longitude,
                    "radius": radius
                ],
                tokenIncluded: false,
                decodeType: GeoPerformanceListResDTO.self
            ) {
                print("공연맵 조회 완료")
                proimse(.success($0.performanceMapList.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Test

final class TestPerformanceMapRepo: GeoPerformanceRepo {
    func getGeoPerformanceInfo(
        coord: CLLocationCoordinate2D,
        radius: Double
    ) -> AnyPublisher<[GeoPerformanceInfo], Never> {
        Just([
            .init(
                id: 1,
                thumbnailPath: "https://example.com/thumbs/1.jpg",
                artist: "아티스트1",
                title: "[강남] 버스킹 페스티벌 1",
                genre: "재즈",
                date: "2025.08.12",
                time: "19:30",
                location: "서울 강남구 역삼동 123-1",
                latitude: 37.491632,
                longitude: 127.021321
            ),
            .init(
                id: 2,
                thumbnailPath: "https://example.com/thumbs/2.jpg",
                artist: "아티스트2",
                title: "[강남] 버스킹 페스티벌 2",
                genre: "클래식",
                date: "2025.08.17",
                time: "20:00",
                location: "서울 강남구 삼성동 456-7",
                latitude: 37.502843,
                longitude: 127.035441
            ),
            .init(
                id: 3,
                thumbnailPath: "https://example.com/thumbs/3.jpg",
                artist: "아티스트3",
                title: "[강남] 버스킹 페스티벌 3",
                genre: "팝",
                date: "2025.08.23",
                time: "18:30",
                location: "서울 강남구 논현동 89-10",
                latitude: 37.496472,
                longitude: 127.029321
            ),
            .init(
                id: 4,
                thumbnailPath: "https://example.com/thumbs/4.jpg",
                artist: "아티스트4",
                title: "[강남] 버스킹 페스티벌 4",
                genre: "록",
                date: "2025.08.09",
                time: "21:00",
                location: "서울 강남구 신사동 12-34",
                latitude: 37.514239,
                longitude: 127.020154
            ),
            .init(
                id: 5,
                thumbnailPath: "https://example.com/thumbs/5.jpg",
                artist: "아티스트5",
                title: "[강남] 버스킹 페스티벌 5",
                genre: "EDM",
                date: "2025.08.19",
                time: "20:30",
                location: "서울 강남구 청담동 56-78",
                latitude: 37.519481,
                longitude: 127.041921
            ),
            .init(
                id: 6,
                thumbnailPath: "https://example.com/thumbs/6.jpg",
                artist: "아티스트6",
                title: "[강남] 버스킹 페스티벌 6",
                genre: "발라드",
                date: "2025.08.04",
                time: "19:00",
                location: "서울 강남구 도곡동 98-76",
                latitude: 37.492314,
                longitude: 127.045633
            ),
            .init(
                id: 7,
                thumbnailPath: "https://example.com/thumbs/7.jpg",
                artist: "아티스트7",
                title: "[강남] 버스킹 페스티벌 7",
                genre: "인디",
                date: "2025.08.15",
                time: "18:00",
                location: "서울 강남구 개포동 65-12",
                latitude: 37.483671,
                longitude: 127.060451
            ),
            .init(
                id: 8,
                thumbnailPath: "https://example.com/thumbs/8.jpg",
                artist: "아티스트8",
                title: "[강남] 버스킹 페스티벌 8",
                genre: "R&B",
                date: "2025.08.27",
                time: "21:30",
                location: "서울 강남구 세곡동 45-90",
                latitude: 37.467208,
                longitude: 127.107514
            ),
            .init(
                id: 9,
                thumbnailPath: "https://example.com/thumbs/9.jpg",
                artist: "아티스트9",
                title: "[강남] 버스킹 페스티벌 9",
                genre: "트로트",
                date: "2025.08.21",
                time: "20:00",
                location: "서울 강남구 자곡동 33-45",
                latitude: 37.478421,
                longitude: 127.097154
            ),
            .init(
                id: 10,
                thumbnailPath: "https://example.com/thumbs/10.jpg",
                artist: "아티스트10",
                title: "[강남] 버스킹 페스티벌 10",
                genre: "어쿠스틱",
                date: "2025.08.30",
                time: "19:30",
                location: "서울 강남구 일원동 77-21",
                latitude: 37.489032,
                longitude: 127.083421
            )
        ])
        .eraseToAnyPublisher()
    }
}
