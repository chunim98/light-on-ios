//
//  NotificationTableView.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit

final class NotificationTableView: UITableView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UITableViewDiffableDataSource<Section, NotificationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NotificationItem>
    
    // MARK: Properties
    
    private var diffableDataSource: DataSource?

    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero, style: .plain)
        contentInset = .init(bottom: 30)
        setupDefaults()
        setupDiffableDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.id)
        backgroundColor = .clear
        separatorStyle = .none
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(tableView: self) {
            tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationCell.id,
                for: indexPath
            ) as? NotificationCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [NotificationItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}

// MARK: - Preview

#Preview { UINavigationController(rootViewController: NotificationVC()) }
