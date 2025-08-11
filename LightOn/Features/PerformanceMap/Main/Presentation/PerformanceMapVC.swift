//
//  PerformanceMapVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//

import UIKit
import SwiftUI
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
    
    /// 마커 그리기 및 상태 업데이트
    private lazy var markersBuilder = MarkersBuilder(mapView.mapView)
    /// 위치 권한 요청 및 현재 위치 가져오기 (위치 초기화용)
    private lazy var locationManager = LocationManager()
    
    /// 네이버 지도 뷰
    private let mapView = NaverMapView()
    /// 공연 리스트 커스텀 모달
    private let listModal = MapListModalView()
    /// 공연 개요 커스텀 모달
    private let summaryModal = MapSummaryModalView()
    /// 검색 모달을 열기 위한 서치바 품은 버튼
    private let searchBarButton = MapSearchBarButton()
    /// 검색 풀 스크린 모달
    private let mapSearchVC = MapSearchVC()
    /// 공연 필터 버튼 뷰
    private let filterView = {
        let hc = UIHostingController(rootView: MapFilterView(vm: .init()))
        hc.view.backgroundColor = .clear
        return hc
    }()
    /// 재검색 버튼
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.addContentInset(.init(top: view.safeAreaInsets.top)) // 지도 상단 패딩 추가
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { navigationController?.navigationBar.isHidden = true }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(listModal)
        view.addSubview(summaryModal)
        view.addSubview(searchBarButton)
        view.addSubview(filterView.view)
        view.addSubview(refreshButton)
        
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        listModal.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            listModalBottmConstraint = $0.bottom.equalToSuperview()
                .constraint
        }
        summaryModal.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            summaryModalBottmConstraint = $0.bottom.equalToSuperview()
                .inset(-280).constraint // 초기에는 아래로 숨김
        }
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        filterView.view.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).inset(-12)
            $0.horizontalEdges.equalToSuperview()
        }
        refreshButton.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).inset(-12)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 최초 실행 좌표 (현재 위치)
        let initialCoord = locationManager.currentCoordPublisher
            .first().append(Empty()) // 종료 없이 1회만 방출
            .eraseToAnyPublisher()
        
        /// 재검색 좌표
        let refreshCoord = refreshButton.tapPublisher
            .withLatestFrom(mapView.cameraCoordPublisher) { _, coord in coord }
            .eraseToAnyPublisher()
        
        /// 선택한 테이블 셀 (마커로 카메라 이동)
        let selectedCellItem = listModal.mapTableView.selectedModelPublisher(
            dataSource: listModal.mapTableView.diffableDataSource
        )
        
        /// 선택한 마커의 공연 ID
        let selectedMarkerID = markersBuilder.selectedMarkerPublisher
            .map { Int?.some($0.performaceID) }
        
        /// 선택한 셀의 공연 ID
        let selectedCellItemID = selectedCellItem
            .map { Int?.some($0.performanceID) }
            .eraseToAnyPublisher()
        
        /// 선택 해제 트리거들 (지도 탭, 뒤로가기 버튼)
        let deselectTrigger = Publishers
            .Merge3(
                mapView.mapTapPublisher,
                summaryModal.backButton.tapPublisher,
                refreshButton.tapPublisher
            )
            .map { Int?.none }
        
        /// 선택된 공연 ID (마커 선택 & 해제)
        let selectedPerformanceID = Publishers
            .Merge3(selectedCellItemID, selectedMarkerID, deselectTrigger)
            .eraseToAnyPublisher()
        
        let input = PerformanceMapVM.Input(
            initialCoord: initialCoord,
            refreshCoord: refreshCoord,
            filterType: filterView.rootView.filterPublisher,
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
                self?.markersBuilder.bindSelectedState(with: $0)
                self?.summaryModal.bindPerfomanceInfo($0)
                self?.bindModalHidden($0)
            }
            .store(in: &cancellables)
        
        output.viewState
            .sink { [weak self] in self?.bindViewState($0) }
            .store(in: &cancellables)
        
        // 레플리카 버튼 탭, 서치 뷰 모달 열기
        searchBarButton.tapPublisher
            .sink { [weak self] in self?.showMapSearchVC() }
            .store(in: &cancellables)
        
        // 서치바 텍스트를 레플리카 버튼에 연동
        mapSearchVC.searchBar.textPublisher
            .sink { [weak self] in self?.searchBarButton.searchBar.textField.text = $0 }
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
        filterView.view.isHidden = state.filterViewHidden
    }
    
    /// 서치 뷰 풀스크린 모달 열기
    private func showMapSearchVC() {
        mapSearchVC.modalPresentationStyle = .overFullScreen
        mapSearchVC.modalTransitionStyle = .crossDissolve
        present(mapSearchVC, animated: true)
    }
}

// MARK: - Preview

#Preview { PerformanceMapVC() }
#Preview { TabBarController() }
