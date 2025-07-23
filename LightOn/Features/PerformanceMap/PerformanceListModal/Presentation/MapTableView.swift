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
    
    typealias DataSource = UITableViewDiffableDataSource<Section, MediumPerformanceCellItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MediumPerformanceCellItem>
    
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
        register(MediumPerformanceTableCell.self, forCellReuseIdentifier: MediumPerformanceTableCell.id)
        contentInset = .init(top: 8)
        backgroundColor = .clear
        separatorStyle = .none
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(tableView: self) {
            tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MediumPerformanceTableCell.id,
                for: indexPath
            ) as? MediumPerformanceTableCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [MediumPerformanceCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
