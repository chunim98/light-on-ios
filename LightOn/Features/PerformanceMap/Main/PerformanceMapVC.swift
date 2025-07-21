//
//  PerformanceMapVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PerformanceMapVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = PerformanceMapDI.shared.makePerformanceMapVM()
    
    // MARK: Components
    
    private let mapView = NaverMapView()
    private let listModal = MapListModalView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        mapView.startLocationManager()  // 화면 표시 시, 위치 매니저 초기화
        mapView.markersBuilder.setMakers(MarkerInfo.mocks) // temp
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(listModal)
        
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        listModal.snp.makeConstraints { $0.bottom.horizontalEdges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = PerformanceMapVM.Input(
            cameraLocation: mapView.cameraLocationPublisher
        )
        
        let output = vm.transform(input)
        
        output.cellItems
            .sink { [weak self] in self?.listModal.mapTableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.markerInfoArr
            .sink { [weak self] in self?.mapView.markersBuilder.setMakers($0) }
            .store(in: &cancellables)
        
        // 최초 1회 현재 위치로 카메라 이동
        mapView.locationManager.locationPublisher.first()
            .sink { [weak self] in self?.mapView.setCamera(
                latitude: $0.latitude,
                longitude: $0.longitude
            ) }
            .store(in: &cancellables)
        
        mapView.dongNamePublisher
            .sink { [weak self] in self?.listModal.bindTitle($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Public Configuration
    
    // MARK: Binders & Publishers
    
}

// MARK: - Preview

#Preview { PerformanceMapVC() }
#Preview { TabBarController() }
