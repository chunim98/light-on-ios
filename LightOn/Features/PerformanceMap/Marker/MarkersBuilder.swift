//
//  MarkersBuilder.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//

import UIKit
import Combine

import NMapsMap

final class MarkersBuilder {
    
    // MARK: Outputs
    
    /// 선택된 마커 정보 서브젝트
    private let selectedMarkerSubject = PassthroughSubject<MarkerInfo, Never>()
    
    // MARK: Components
    
    private weak var mapView: NMFMapView?
    private var markers: [LOMarker] = []
    
    // MARK: Life Cycle
    
    init(_ mapView: NMFMapView?) {
        self.mapView = mapView
    }
    
    // MARK: Public Configuration
    
    /// 지도에 마커들 생성
    func setMakers(_ infoArr: [MarkerInfo]) {
        markers.forEach { $0.mapView = nil }                // 기존 마커 지우기
        markers = infoArr.map { LOMarker(
            info: $0,
            mapView: mapView,
            selectedMarkerSubject: selectedMarkerSubject    // 마커 선택 수신 서브젝트
        ) }
    }
}

// MARK: Binders & Publishers

extension MarkersBuilder {
    /// 마커 선택 상태 바인딩
    func bindSelectedState(with info: GeoPerformanceInfo?) {
        guard let info else { markers.forEach { $0.state = .idle }; return }
        markers.forEach {
            $0.state = ($0.info.performaceID == info.id) ? .selected : .deselected
        }
    }
    
    /// 선택된 마커 정보 퍼블리셔
    var selectedMarkerPublisher: AnyPublisher<MarkerInfo, Never> {
        selectedMarkerSubject.eraseToAnyPublisher()
    }
}

