//
//  MapSearchVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MapSearchVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = PerformanceMapDI.shared.makeMapSearchVM()
    
    // MARK: Components
    
    let searchBar = MapSearchBar()
    
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
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = MapSearchVM.Input(
            address: searchBar.textPublisher,
            trigger: searchBar.textField.controlEventPublisher(for: .editingDidEnd)
        )
        
        let output = vm.transform(input)
        
        output.coord
            .sink { [weak self] in print($0) }
            .store(in: &cancellables)
    
        // 검색 완료 시 일단 화면 닫기, 일단은...
        searchBar.textField.controlEventPublisher(for: .editingDidEnd)
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { MapSearchVC() }
