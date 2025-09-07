//
//  MyActivityHistoryVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyActivityHistoryVC: BackButtonVC {
    
    // MARK: PerfType
    
    enum PerfType { case concert(id: Int), busking(id: Int) }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Subjects
    
    /// 등록한 공연 ID서브젝트(출력)
    private let registeredIDSubject = PassthroughSubject<PerfType, Never>()
    
    // MARK: Components
    
    private let scrollView = ResponsiveScrollView()
    private let contentVStack = UIStackView(.vertical)
    
    private let statsVC = MyStatsVC()
    private let preferredVC = MyPreferredVC()
    private let applicationVC = MyApplicationRequestedVC()
    private let registaionVC = MyRegistrationRequestedVC()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "내 활동 내역"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(statsVC)
        addChild(preferredVC)
        addChild(registaionVC)
        addChild(applicationVC)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(statsVC.view)
        contentVStack.addArrangedSubview(preferredVC.view)
        contentVStack.addArrangedSubview(
            LODivider(height: 12, color: .background)
        )
        contentVStack.addArrangedSubview(registaionVC.view)
        contentVStack.addArrangedSubview(
            LODivider(height: 1, color: .background)
        )
        contentVStack.addArrangedSubview(applicationVC.view)
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        
        statsVC.didMove(toParent: self)
        preferredVC.didMove(toParent: self)
        registaionVC.didMove(toParent: self)
        applicationVC.didMove(toParent: self)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 등록한 공연을 선택했을 때,
        // 버스킹인지 콘서트인지 구분해서 아이디와 함께 외부로 방출
        registaionVC.tableView.selectedModelPublisher(
            dataSource: registaionVC.tableView.diffableDataSource
        )
        .map {
            $0.isConcert
            ? PerfType.concert(id: $0.id)
            : PerfType.busking(id: $0.id)
        }
        .sink(receiveValue: registeredIDSubject.send(_:))
        .store(in: &cancellables)
    }
}

extension MyActivityHistoryVC {
    /// 관람 신청 내역 상세 탭 퍼블리셔
    var applicationDetailTapPublisher: AnyPublisher<Void, Never> {
        applicationVC.detailButton.tapPublisher
    }
    
    /// 공연 등록 내역 상세 탭 퍼블리셔
    var registaionDetailTapPublisher: AnyPublisher<Void, Never> {
        registaionVC.detailButton.tapPublisher
    }
    
    /// 등록한 공연 ID 퍼블리셔
    var registeredIDPublisher: AnyPublisher<PerfType, Never> {
        registeredIDSubject.eraseToAnyPublisher()
    }
    
    /// 신청한 공연 아이디 퍼블리셔
    var appliedIDPublisher: AnyPublisher<Int, Never> {
        applicationVC.tableView.selectedModelPublisher(
            dataSource: applicationVC.tableView.diffableDataSource
        )
        .map { $0.id }
        .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { MyActivityHistoryVC() }
