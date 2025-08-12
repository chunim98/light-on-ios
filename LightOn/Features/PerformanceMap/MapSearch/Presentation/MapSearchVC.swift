//
//  MapSearchVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import UIKit
import Combine
import CoreLocation

import CombineCocoa
import SnapKit

final class MapSearchVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = PerformanceMapDI.shared.makeMapSearchVM()
    
    // MARK: Subjects
    
    /// 선택한 아이템 서브젝트
    private let selectedItemSubject = PassthroughSubject<MapSearchCellItem, Never>()
    
    // MARK: Components
    
    let searchBar = MapSearchBar()
    
    let tableView = MapSearchTableView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.textField.becomeFirstResponder() // 화면 뜨자마자 키보드 표시
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { view.backgroundColor = .white }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).inset(-10)
            $0.bottom.equalTo(view.keyboardLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedItem = tableView.selectedModelPublisher(
            dataSource: tableView.diffableDataSource
        )
        
        let input = MapSearchVM.Input(address: searchBar.textPublisher)
        let output = vm.transform(input)
        
        output.searchResults
            .sink { [weak self] in self?.tableView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        selectedItem
            .sink { [weak self] in self?.selectedItemSubject.send($0) }
            .store(in: &cancellables)
        
        // 키패드리턴/ 검색결과 선택 시 화면 닫기
        Publishers
            .Merge(
                searchBar.textField.controlEventPublisher(for: .editingDidEnd),
                selectedItem.map { _ in }
            )
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MapSearchVC {
    /// 사용자 검색 좌표 퍼블리셔
    var searchedCoordPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
        selectedItemSubject.map { $0.coord }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { MapSearchVC() }
