//
//  MyRegistrationRequestedFullVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyRegistrationRequestedFullVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyActivityHistoryDI.shared.makeMyRegistrationRequestedFullVM()
    
    // MARK: Components
    
    private let tableView = MyPerformanceTableView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "공연 등록 내역"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 선택한 공연 아이디 퍼블리셔
        let selectedID = tableView
            .selectedModelPublisher(dataSource: tableView.diffableDataSource)
            .map { $0.id }
            .eraseToAnyPublisher()
        
        let input = MyRegistrationRequestedFullVM.Input(trigger: viewDidAppearPublisher)
        let output = vm.transform(input)
        
        output.requests
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
#warning("일단 버스킹인지 일반공연인지 구분하지 않고, 버스킹 수정으로 진입시키고 있음")
        // 공연 선택하면 공연 수정화면으로 이동
        selectedID
            .sink { AppCoordinatorBus.shared.navigate(to: .editBusking(id: $0)) }
            .store(in: &cancellables)
    }
}
