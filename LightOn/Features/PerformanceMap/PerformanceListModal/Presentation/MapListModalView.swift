//
//  MapListModalView.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import UIKit
import Combine
import CoreLocation

import CombineCocoa
import SnapKit

final class MapListModalView: MapGrabberModalView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = PerformanceMapDI.shared.makeMapListModalVM()
    
    // MARK: Inputs
    
    private let cameraLocationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    // MARK: Components
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(19)
        config.foregroundColor = .loBlack
        config.text = "위치 조회 중.."
        return LOPaddingLabel(
            configuration: config,
            padding: .init(top: 12, bottom: 8)
        )
    }()
    
    let mapTableView = MapTableView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addArrangedSubview(mapTableView)
        grabberHeaderVStack.addArrangedSubview(titleLabel)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = MapListModalVM.Input(
            cameraLocation: cameraLocationSubject.eraseToAnyPublisher()
        )
        
        let output = vm.transform(input)
        
        output.dongName
            .sink { [weak self] in
                self?.titleLabel.config.text = $0 ?? "위치 조회 중.."
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MapListModalView {
    /// 지오코딩 좌표 바인딩
    func bindGeocodingCoord(_ coord: CLLocationCoordinate2D) {
        cameraLocationSubject.send(coord)
    }
}
