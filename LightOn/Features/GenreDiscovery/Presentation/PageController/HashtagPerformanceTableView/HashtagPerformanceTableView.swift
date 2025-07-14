//
//  HashtagPerformanceTableView.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit

final class HashtagPerformanceTableView: UITableView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UITableViewDiffableDataSource<Section, HashtagPerformanceCellItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HashtagPerformanceCellItem>
    
    // MARK: Properties
    
    private var diffableDataSource: DataSource?

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
        register(HashtagPerformanceCell.self, forCellReuseIdentifier: HashtagPerformanceCell.id)
        contentInset = .init(top: 16, bottom: 4) // 셀 자체 하단인셋(12) 고려
        backgroundColor = .clear
        separatorStyle = .none
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(tableView: self) {
            tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HashtagPerformanceCell.id,
                for: indexPath
            ) as? HashtagPerformanceCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [HashtagPerformanceCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}
