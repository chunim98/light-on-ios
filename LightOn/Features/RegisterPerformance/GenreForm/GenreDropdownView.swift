//
//  GenreDropdownView.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class GenreDropdownView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = GenreFormVM()
    
    // MARK: Inputs
    
    private let dismissTableEventSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Outputs
    
    private let selectedGenreIDSubject = PassthroughSubject<Int?, Never>()
    
    // MARK: Components
    
    let button = DropdownButton(defaultTitle: "장르를 선택해 주세요")
    let tableContainer = TableContainerView()
    let tableView = GenreTableView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(button)
    }
    
    /// 오버레이 레이아웃 구성 (부모 뷰에서 구성해야 함)
    func setupOverlayLayout(superView: UIView) {
        superView.addSubview(tableContainer)
        tableContainer.addArrangedSubview(tableView)
        
        tableContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(button)
            $0.height.equalTo(329)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedGenre = tableView.selectedModelPublisher(
            dataSource: tableView.diffableDataSource
        )
        
        let input = GenreFormVM.Input(
            buttonTap: button.tapPublisher,
            dismissTableEvent: dismissTableEventSubject.eraseToAnyPublisher(),
            selectedGenre: selectedGenre
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState($0) }
            .store(in: &cancellables)
        
        output.selectedGenreID
            .sink { [weak self] in self?.selectedGenreIDSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension GenreDropdownView {
    /// 상태 바인딩
    private func bindState(_ state: GenreDropdownState) {
        tableContainer.isHidden = state.tableHidden
        button.setState({
            guard let item = state.selectedGenre else { return .idle }
            return .filled(item.title)
        }())
    }
    
    /// 테이블 뷰 닫기 바인딩
    func bindDismissTable(_ gesture: UITapGestureRecognizer) {
        // 부모 뷰 기준 포인트 계산
        let point = gesture.location(in: tableContainer.superview)
        
        // 오버레이가 열려있고, 배경을 탭하면 닫기
        if !tableContainer.isHidden, !tableContainer.frame.contains(point) {
            dismissTableEventSubject.send(())
        }
    }
    
    /// 선택한 장르 아이디 퍼블리셔
    var genreIDPublisher: AnyPublisher<Int?, Never> {
        selectedGenreIDSubject.eraseToAnyPublisher()
    }
}
