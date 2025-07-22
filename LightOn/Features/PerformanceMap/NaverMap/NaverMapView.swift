//
//  NaverMapView.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//
// 네이버 지도 문서
// https://navermaps.github.io/ios-map-sdk/guide-ko/2-3.html

import UIKit
import Combine
import CoreLocation

import NMapsMap

final class NaverMapView: NMFNaverMapView {
    
    // MARK: Inputs
    
    /// 카메라 이동 이벤트(원인) 서브젝트
    private let cameraDidChangeSubject = PassthroughSubject<NMFMapChangedReason, Never>()
    /// 지도 탭 서브젝트
    private let didTapMapSubject = PassthroughSubject<Void, Never>()
    
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
        mapView.touchDelegate = self                // 지도 터치 이벤트 델리게이트
        mapView.addCameraDelegate(delegate: self)   // 카메라 변경 이벤트 델리게이트
        mapView.extent = NMGLatLngBounds(           // 카메라 영역 한반도 인근으로 제한
            southWestLat: 31.43,
            southWestLng: 122.37,
            northEastLat: 44.35,
            northEastLng: 132
        )
        mapView.maxZoomLevel = 16.0                 // 최대 줌 레벨 제한
        mapView.minZoomLevel = 6.0                  // 최소 줌 레벨 제한
        mapView.positionMode = .normal              // 위치 추적 설정
        showLocationButton = true                   // 현위치 버튼 표시 여부
        showZoomControls = false                    // 줌 버튼 표시 여부
        mapView.contentInset = .init(bottom: 270)   // 하단 콘텐츠 인셋
    }
    
    // MARK: Public Configuration
    
    /// 카메라 위치 이동
    func setCamera(_ coord: CLLocationCoordinate2D) {
        let position = NMGLatLng(lat: coord.latitude, lng: coord.longitude)
        let camera = NMFCameraPosition(position, zoom: mapView.zoomLevel)
        let update = NMFCameraUpdate(position: camera)
        update.animationDuration = 1.0
        update.animation = .fly
        mapView.moveCamera(update)
    }
    
    /// 콘텐츠 패딩 추가
    func addContentInset(_ inset: UIEdgeInsets) {
        mapView.contentInset = mapView.contentInset + inset
    }
}

// MARK: Binders & Publishers

extension NaverMapView {
    /// 카메라 이동 이벤트(원인) 퍼블리셔
    var cameraDidChangePublisher: AnyPublisher<NMFMapChangedReason, Never> {
        cameraDidChangeSubject.eraseToAnyPublisher()
    }
    
    /// 카메라 좌표 퍼블리셔
    var cameraCoordPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
        cameraDidChangeSubject
            .compactMap { [weak self] _ in self?.mapView.cameraPosition.target }
            .map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }
            .eraseToAnyPublisher()
    }
    
    /// 지도 탭 퍼블리셔
    var mapTapPublisher: AnyPublisher<Void, Never> {
        didTapMapSubject.eraseToAnyPublisher()
    }
}

// MARK: - NMFMapViewCameraDelegate

extension NaverMapView: NMFMapViewCameraDelegate {
    /// 카메라의 움직임이 끝났을 때 호출되는 콜백 메서드
    func mapView(
        _ mapView: NMFMapView,
        cameraDidChangeByReason reason: Int,
        animated: Bool
    ) {
        guard let reason = NMFMapChangedReason(rawValue: reason) else { return }
        cameraDidChangeSubject.send(reason)
    }
}

// MARK: - NMFMapViewTouchDelegate

extension NaverMapView: NMFMapViewTouchDelegate {
    /// 지도가 탭되면 호출되는 콜백 메서드
    func mapView(
        _ mapView: NMFMapView,
        didTapMap latlng: NMGLatLng,
        point: CGPoint
    ) {
        didTapMapSubject.send(())
    }
}

// MARK: - Preview

#Preview { NaverMapView() }
