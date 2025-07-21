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

import NMapsMap

final class NaverMapView: NMFNaverMapView {
    
    // MARK: Properties
    
    private let vm = PerformanceMapDI.shared.makeNaverMapVM()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var markersBuilder = MarkersBuilder(mapView: mapView)
    private(set) var locationManager: LocationManager!
    
    // MARK: Inputs
    
    private let cameraDidChangeSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Outputs
    
    private let cameraLocationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    private let dongNameSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        mapView.addCameraDelegate(delegate: self)   // 카메라 변경 이벤트 델리게이트
        mapView.extent = NMGLatLngBounds(           // 카메라 영역 한반도 인근으로 제한
            southWestLat: 31.43,
            southWestLng: 122.37,
            northEastLat: 44.35,
            northEastLng: 132
        )
        mapView.maxZoomLevel = 18.0                 // 최대 줌 레벨 제한
        mapView.minZoomLevel = 6.0                  // 최소 줌 레벨 제한
        mapView.positionMode = .normal              // 위치 추적 설정
        showLocationButton = true                   // 현위치 버튼 표시 여부
        showZoomControls = false                    // 줌 버튼 표시 여부
        
        mapView.contentInset = .init(bottom: 250)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 현재 카메라 좌표
        let cameraLocation = cameraDidChangeSubject
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .compactMap { [weak self] in self?.mapView.cameraPosition.target }
            .map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }
            .eraseToAnyPublisher()
        
        let input = NaverMapVM.Input(cameraLocation: cameraLocation)
        let output = vm.transform(input)
        
        output.dongName
            .sink { [weak self] in self?.dongNameSubject.send($0) }
            .store(in: &cancellables)
        
        cameraLocation
            .sink { [weak self] in self?.cameraLocationSubject.send($0) }
            .store(in: &cancellables)
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

// MARK: Binders & Publishers

extension NaverMapView {
    /// 카메라 좌표 퍼블리셔
    var cameraLocationPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
        cameraLocationSubject.eraseToAnyPublisher()
    }
    
    /// 카메라 좌표 기준, 동 이름 퍼블리셔
    var dongNamePublisher: AnyPublisher<String?, Never> {
        dongNameSubject.eraseToAnyPublisher()
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
        cameraDidChangeSubject.send(())
    }
}

// MARK: - Preview

#Preview { NaverMapView() }
