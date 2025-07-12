//
//  GenreTableView.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import UIKit

final class GenreTableView: UITableView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    // 회원가입/ 선호장르 선택/ GenreCellItem 참조
    typealias DataSource = UITableViewDiffableDataSource<Section, GenreCellItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GenreCellItem>
    
    // MARK: Properties
    
    private(set) var diffableDataSource: DataSource?
    
    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero, style: .plain)
        setupDefaults()
        setupDiffableDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        register(DropdownCell.self, forCellReuseIdentifier: DropdownCell.id)
        separatorStyle = .none
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(tableView: self) {
            tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DropdownCell.id,
                for: indexPath
            ) as? DropdownCell else { return .init() }
            
            cell.configure(text: item.title)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [GenreCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}
