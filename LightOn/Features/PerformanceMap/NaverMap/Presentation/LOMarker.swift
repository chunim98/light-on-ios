//
//  LOMarker.swift
//  LightOn
//
//  Created by 신정욱 on 7/17/25.
//

import UIKit
import Combine

import NMapsMap

final class LOMarker: NMFMarker {
    
    // MARK: Enum
    
    enum State { case idle, selected, deselected }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    let info: MarkerInfo
    
    // MARK: Inputs
    
    @Published var state: State = .idle
    
    // MARK: Outputs
    
    private weak var selectedMarkerSubject: PassthroughSubject<MarkerInfo, Never>?
    
    // MARK: Life Cycle
    
    init(
        info: MarkerInfo,
        mapView: NMFMapView?,
        selectedMarkerSubject: PassthroughSubject<MarkerInfo, Never>
    ) {
        self.selectedMarkerSubject = selectedMarkerSubject
        self.info = info
        super.init()
        setupDefaults(mapView)
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults(_ mapView: NMFMapView?) {
        touchHandler = { [weak self, info] _ in
            self?.selectedMarkerSubject?.send(info) // 탭 이벤트 방출
            return true                             // 이벤트 전파 안 함
        }
        position = NMGLatLng(
            lat: info.latitude,
            lng: info.longitude
        )
        self.mapView = mapView
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 상태에 따라 마커 이미지 변경
        $state.sink { [weak self] in
            self?.iconImage = NMFOverlayImage(
                image: ($0 == .deselected)
                ? .mapMarkerInactive
                : .mapMarkerActive
            )
            self?.zIndex = ($0 == .deselected) ? 0 : 10
        }
        .store(in: &cancellables)
    }
}
