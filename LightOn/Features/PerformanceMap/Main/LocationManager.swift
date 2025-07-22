//
//  LocationManager.swift
//  LightOn
//
//  Created by 신정욱 on 7/17/25.
//

import UIKit
import Combine
import CoreLocation

final class LocationManager: CLLocationManager {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Inputs
    
    private let authStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    
    // MARK: Outputs
    
    private let currentCoordSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    // MARK: Life Cycle
    
    override init() {
        super.init()
        setupDefaults()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { delegate = self }
    
    // MARK: Bindings
    
    private func setupBindings() {
        authStatusSubject
            .sink { [weak self] in self?.bindAuthStatus($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension LocationManager {
    /// 인증 상태 바인딩
    private func bindAuthStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("위치 권한: 요청 전 상태")
            requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 권한: 이미 허용됨")
            startUpdatingLocation()
            
        case .restricted, .denied:
            print("위치 권한: 접근 거부됨")
            
        @unknown default:
            print("위치 권한: 알 수 없는 상태")
        }
    }
    
    /// 현재 좌표 퍼블리셔 (지속 업데이트 됨)
    var currentCoordPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
        currentCoordSubject.eraseToAnyPublisher()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    /// 위치 권한 상태가 변경될 때 호출됨
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        authStatusSubject.send(status)
    }
    
    /// 위치가 새로 업데이트될 때마다 호출됨
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let coord = manager.location?.coordinate else { return }
        currentCoordSubject.send(coord)
    }
}
