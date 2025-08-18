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
        let input = MyRegistrationRequestedFullVM.Input(trigger: viewDidAppearPublisher)
        let output = vm.transform(input)
        
        output.requests
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
    }
}
