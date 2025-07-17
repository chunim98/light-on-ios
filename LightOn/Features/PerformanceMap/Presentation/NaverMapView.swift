//
//  NaverMapView.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//
// 네이버 지도 문서
// https://navermaps.github.io/ios-map-sdk/guide-ko/2-3.html

import UIKit

import NMapsMap

final class NaverMapView: NMFNaverMapView {
    
    // MARK: Properties
    
    private(set) lazy var markersBuilder = MarkersBuilder(mapView: mapView)
    private(set) var locationManager: LocationManager!
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        mapView.positionMode = .normal  // 위치 추적 설정
        showLocationButton = true       // 현위치 버튼 표시 여부
        showZoomControls = false        // 줌 버튼 표시 여부
    }
    
    // MARK: Public Configuration
    
    /// 위치 매니저 초기화 (화면 표시 시점에 사용 권장)
    func startLocationManager() {
        locationManager = LocationManager()
    }
    
    /// 카메라 위치 이동
    func setCamera(latitude: Double, longitude: Double) {
        let position = NMGLatLng(lat: latitude, lng: longitude)
        let camera = NMFCameraPosition(position, zoom: 15)
        let update = NMFCameraUpdate(position: camera)
        mapView.moveCamera(update)
    }
}
