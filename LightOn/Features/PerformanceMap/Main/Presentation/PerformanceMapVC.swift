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
    
    private var summaryModalBottmConstraint: Constraint?
    private var listModalBottmConstraint: Constraint?
    
    // MARK: Components
    
    private lazy var markersBuilder = MarkersBuilder(mapView.mapView)
    private lazy var locationManager = LocationManager()
    
    private let summaryModal = MapSummaryModalView()
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
        view.addSubview(summaryModal)
        view.addSubview(refreshButton)
        
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        listModal.snp.makeConstraints {
            listModalBottmConstraint = $0.bottom.equalToSuperview().constraint
            $0.horizontalEdges.equalToSuperview()
        }
        summaryModal.snp.makeConstraints {
            summaryModalBottmConstraint = $0.bottom.equalToSuperview().constraint
            $0.horizontalEdges.equalToSuperview()
        }
        refreshButton.snp.makeConstraints { $0.top.centerX.equalTo(view.safeAreaLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 최초 실행 좌표 (현재 위치)
        let initialCoord = locationManager.currentCoordPublisher
            .first().append(Empty())    // 종료 없이 1회만 방출
            .eraseToAnyPublisher()
        
        /// 재검색 좌표
        let refreshCoord = refreshButton.tapPublisher
            .withLatestFrom(mapView.cameraCoordPublisher) { _, coord in coord }
            .eraseToAnyPublisher()
        
        /// 선택한 테이블 셀 (마커로 카메라 이동)
        let selectedCellItem = listModal.mapTableView.selectedModelPublisher(
            dataSource: listModal.mapTableView.diffableDataSource
        )
        
        /// 선택한 공연 (선택한 마커)
        let selectedPerformanceID = Publishers.Merge(
            markersBuilder.selectedMarkerPublisher.map { Int?.some($0.performaceID) },
            mapView.mapTapPublisher.map { Int?.none }   // 지도 배경 탭하면 선택 해제
        ).eraseToAnyPublisher()
        
        let input = PerformanceMapVM.Input(
            initialCoord: initialCoord,
            refreshCoord: refreshCoord,
            cameraChanged: mapView.cameraDidChangePublisher,
            selectedCellItem: selectedCellItem,
            selectedID: selectedPerformanceID
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
        
        output.selectedPerformance
            .sink { [weak self] in
                self?.markersBuilder.bindDeselectAll(with: $0)
                self?.summaryModal.configure(with: $0)
                self?.bindModalHidden($0)
            }
            .store(in: &cancellables)
        
        output.viewState
            .sink { [weak self] in self?.bindViewState($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PerformanceMapVC {
    /// 모달 표시 여부 바인딩
    private func bindModalHidden(_ info: GeoPerformanceInfo?) {
        // 내부는 즉시 레이아웃 갱신 (애니메이션 전파 막기)
        UIView.performWithoutAnimation {
            summaryModal.contentView.layoutIfNeeded()
        }
        
        // 이제 바깥쪽 constraint만 애니메이션
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            let summaryInset    = info == nil ? -summaryModal.frame.height : 0
            let listInset       = info != nil ? -listModal.frame.height : 0
            
            summaryModalBottmConstraint?.update(inset: summaryInset)
            listModalBottmConstraint?.update(inset: listInset)
            view.layoutIfNeeded()
        }
    }
    
    /// 뷰 상태 바인딩
    private func bindViewState(_ state: PerformanceMapState) {
        refreshButton.isHidden = state.refreshButtonHidden
    }
}

// MARK: - Preview

#Preview { PerformanceMapVC() }
#Preview { TabBarController() }
