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
    
    private lazy var markersBuilder = MarkersBuilder(mapView.mapView)
    private lazy var locationManager = LocationManager()
    
    private let listModal = MapListModalView()
    private let mapView = NaverMapView()
    
    private let refreshButton = {
        var titleConfig = AttrConfiguration()
        titleConfig.font = .pretendard.semiBold(14)
        titleConfig.foregroundColor = .white
        titleConfig.text = "현재 위치 재검색"
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(horizontal: 12, vertical: 6)
        config.attributedTitle = .init(config: titleConfig)
        config.baseBackgroundColor = .brand
        config.cornerStyle = .capsule
        config.image = .mapCircularArrow
        config.imagePadding = 4
        let button = UIButton(configuration: config)
        button.isHidden = true
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(listModal)
        view.addSubview(refreshButton)
        
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        listModal.snp.makeConstraints { $0.bottom.horizontalEdges.equalToSuperview() }
        refreshButton.snp.makeConstraints { $0.top.centerX.equalTo(view.safeAreaLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedMarker = markersBuilder.selectedMarkerPublisher
        let selectedCellItem = listModal.mapTableView.selectedModelPublisher(
            dataSource: listModal.mapTableView.diffableDataSource
        )
        
        /// 최초 실행 좌표 (현재 위치)
        let initialCoord = locationManager.currentCoordPublisher
            .first().append(Empty())    // 종료 없이 1회만 방출
            .eraseToAnyPublisher()
        
        /// 재검색 좌표
        let refreshCoord = refreshButton.tapPublisher
            .withLatestFrom(mapView.cameraCoordPublisher) { _, coord in coord }
            .eraseToAnyPublisher()
        
        let input = PerformanceMapVM.Input(
            initialCoord: initialCoord,
            refreshCoord: refreshCoord,
            cameraChanged: mapView.cameraDidChangePublisher,
            selectedCellItem: selectedCellItem
        )
        
        let output = vm.transform(input)
        
        output.cellItems
            .sink { [weak self] in self?.listModal.mapTableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.reverseGeocodingCoord
            .sink { [weak self] in self?.listModal.bindGeocodingCoord($0) }
            .store(in: &cancellables)
        
        output.markerInfoArr
            .sink { [weak self] in self?.markersBuilder.setMakers($0) }
            .store(in: &cancellables)
        
        output.cameraTargetCoord
            .sink { [weak self] in self?.mapView.setCamera($0) }
            .store(in: &cancellables)
        
        output.viewState
            .sink { [weak self] in
                self?.refreshButton.isHidden = $0.refreshButtonHidden
            }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { PerformanceMapVC() }
#Preview { TabBarController() }
