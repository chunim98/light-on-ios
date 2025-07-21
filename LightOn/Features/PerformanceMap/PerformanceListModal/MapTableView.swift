//
//  MapTableView.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import UIKit

final class MapTableView: UITableView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UITableViewDiffableDataSource<Section, SpotlightedCellItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SpotlightedCellItem>
    
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
        register(SpotlightedTableCell.self, forCellReuseIdentifier: SpotlightedTableCell.id)
        contentInset = .init(top: 8)
        backgroundColor = .clear
        separatorStyle = .none
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(tableView: self) {
            tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SpotlightedTableCell.id,
                for: indexPath
            ) as? SpotlightedTableCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [SpotlightedCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
