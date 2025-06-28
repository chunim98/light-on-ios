//
//  AddressTableView.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit

final class AddressTableView: UITableView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UITableViewDiffableDataSource<Section, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
    
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
        register(AddressCell.self, forCellReuseIdentifier: AddressCell.id)
        backgroundColor = .white
        separatorStyle = .none
        
        layer.borderColor = UIColor.thumbLine.cgColor
        layer.borderWidth = 1
        
        layer.cornerRadius = 6
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(tableView: self) {
            tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AddressCell.id,
                for: indexPath
            ) as? AddressCell else { return .init() }
            
            cell.configure(text: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [String]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}

// MARK: - Preview

#Preview { AddressTableView() }
#Preview { SignUpSecondStepVC() }
