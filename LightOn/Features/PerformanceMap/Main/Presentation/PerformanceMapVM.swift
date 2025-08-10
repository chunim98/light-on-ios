//
//  PerformanceMapVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Foundation
import Combine
import CoreLocation

final class PerformanceMapVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 초기 좌표(= 내 위치)
        let initialCoord: AnyPublisher<CLLocationCoordinate2D, Never>
        /// 재검색 좌표
        let refreshCoord: AnyPublisher<CLLocationCoordinate2D, Never>
        /// 검색 필터 타입
        let filterType: AnyPublisher<MapFilterType?, Never>
        /// 지도 카메라 이동 이벤트
        let cameraChanged: AnyPublisher<NMFMapChangedReason, Never>
        /// 선택한 테이블 셀 (마커로 카메라 이동)
        let selectedCellItem: AnyPublisher<MediumPerformanceCellItem, Never>
        /// 선택된 공연 ID
        let selectedID: AnyPublisher<Int?, Never>
    }
    struct Output {
        /// 위치 기반 공연정보 테이블 셀들
        let cellItems: AnyPublisher<[MediumPerformanceCellItem], Never>
        /// 위치 기반 공연정보 마커들
        let markerInfoArr: AnyPublisher<[MarkerInfo], Never>
        /// 리버스 지오코딩 좌표 (타이틀 갱신)
        let reverseGeocodingCoord: AnyPublisher<CLLocationCoordinate2D, Never>
        /// 카메라를 이동시킬 좌표
        let cameraTargetCoord: AnyPublisher<CLLocationCoordinate2D, Never>
        /// 선택한 공연 정보
        let selectedPerformance: AnyPublisher<GeoPerformanceInfo?, Never>
        /// 뷰 상태
        let viewState: AnyPublisher<PerformanceMapState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getGeoPerformanceInfoUC: GetGeoPerformanceInfoUC
    private let getGeoPerformanceSummaryUC = GetGeoPerformanceSummaryUC()
    private let moveCameraUC = MoveCameraUC()
    
    // MARK: Initializer
    
    init(repo: any GeoPerformanceRepo) {
        self.getGeoPerformanceInfoUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 뷰 상태 서브젝트
        let viewStateSubject = CurrentValueSubject<PerformanceMapState, Never>(.init(
            refreshButtonHidden: true, filterViewHidden: false
        ))
        
        /// 좌표 기반 공연 정보
        let performanceInfoArr = getGeoPerformanceInfoUC.execute(
            initialCoord: input.initialCoord,
            refreshCoord: input.refreshCoord,
            filterType: input.filterType
        )
        
        /// 테이블 뷰 데이터 가공
        let cellItems = performanceInfoArr
            .map { $0.map { $0.toCellItem() } }
            .eraseToAnyPublisher()
        
        let markerInfoArr = performanceInfoArr
            .map { $0.map { $0.toMarkerInfo() } }
            .eraseToAnyPublisher()
        
        /// 리버스 지오코딩 좌표
        let reverseGeocodingCoord = Publishers
            .Merge(input.refreshCoord, input.initialCoord)
            .eraseToAnyPublisher()
        
        /// 카메라를 이동시킬 좌표 획득
        let cameraTargetCoord = moveCameraUC.execute(
            initialCoord: input.initialCoord,
            selectedCell: input.selectedCellItem,
            performances: performanceInfoArr
        )
        
        /// 카메라 위치 변경 (사용자 상호작용만 필터)
        let cameraChanged = input.cameraChanged
            .filter { $0 == .gesture }
            .eraseToAnyPublisher()
        
        /// 선택한 공연
        let selectedPerformance = getGeoPerformanceSummaryUC.execute(
            selectedID: input.selectedID,
            performances: performanceInfoArr
        )
        
        // 뷰 상태 갱신
        [
            cameraChanged.sink { _ in
                viewStateSubject.value.refreshButtonHidden = false
                viewStateSubject.value.filterViewHidden = true
            },
            performanceInfoArr.sink { _ in
                viewStateSubject.value.refreshButtonHidden = true
                viewStateSubject.value.filterViewHidden = false
            },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(
            cellItems: cellItems,
            markerInfoArr: markerInfoArr,
            reverseGeocodingCoord: reverseGeocodingCoord,
            cameraTargetCoord: cameraTargetCoord,
            selectedPerformance: selectedPerformance,
            viewState: viewStateSubject.eraseToAnyPublisher()
        )
    }
}
