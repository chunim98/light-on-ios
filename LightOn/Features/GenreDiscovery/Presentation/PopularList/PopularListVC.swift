//
//  PopularListVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit
import SwiftUI
import Combine

import SnapKit

final class PopularListVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = GenreDiscoveryDI.shared.makePopularListVM()
    
    // MARK: Inputs
    
    private let refreshEventSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    
    let tagsView = UIHostingController(rootView: GenreTagsView(vm: .init()))
    private let tableView = HashtagPerformanceTableView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshEventSubject.send(())    // 테이블 뷰 데이터 갱신
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(LOSpacer(20))
        mainVStack.addArrangedSubview(tagsView.view)
        mainVStack.addArrangedSubview(LOSpacer(4))
        mainVStack.addArrangedSubview(tableView)
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 선택한 공연 아이디
        let selectedPerformanceID = tableView
            .selectedModelPublisher(dataSource: tableView.diffableDataSource)
            .map { $0.id }
            .eraseToAnyPublisher()
        
        let input = PopularListVM.Input(
            refreshEvent: refreshEventSubject.eraseToAnyPublisher(),
            genreFilter: tagsView.rootView.selectedGenrePublisher,
            selectedPerformanceID: selectedPerformanceID
        )
        
        let output = vm.transform(input)
        
        output.populars
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { PopularListVC() }
