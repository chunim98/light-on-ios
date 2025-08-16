//
//  MyApplicationRequestedVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyApplicationRequestedVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyActivityHistoryDI.shared.makeMyApplicationRequestedVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    private let headerHStack = UIStackView(
        alignment: .center, inset: .init(horizontal: 16) + .init(top: 30, bottom: 10)
    )
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(19)
        config.foregroundColor = .loBlack
        return LOLabel(config: config)
    }()
    
    let detailButton = {
        var config = UIButton.Configuration.plain()
        config.image = .activityHistoryArrowRight
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let tableView = MyPerformanceTableView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { titleLabel.config.text = "최근 공연 신청 내역" }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(headerHStack)
        mainVStack.addArrangedSubview(tableView)
        
        headerHStack.addArrangedSubview(titleLabel)
        headerHStack.addArrangedSubview(LOSpacer())
        headerHStack.addArrangedSubview(detailButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.snp.makeConstraints { $0.height.equalTo(391) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let loginEvent = SessionManager.shared.loginStatePublisher
            .compactMap { $0 == .login ? Void() : nil }
            .eraseToAnyPublisher()
        
        let trigger = Publishers
            .Merge(viewDidLoadPublisher, loginEvent)
            .eraseToAnyPublisher()
        
        let input = MyApplicationRequestedVM.Input(trigger: trigger)
        let output = vm.transform(input)
        
        output.requests
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
    }
}
