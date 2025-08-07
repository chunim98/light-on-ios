//
//  MyPreferredCollectionView.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

import UIKit

import SnapKit

final class MyPreferredCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias Item = MyPreferredCellItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Properties
    
    private(set) var diffableDataSource: DataSource?
    
    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        setupDefaults()
        setupLayout()
        setupDiffableDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        register(MyPreferredCell.self, forCellWithReuseIdentifier: MyPreferredCell.id)
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        setFixedLayout(
            fixedSize: CGSize(width: 64, height: 90),
            spacing: 12,
            sectionInset: .init(horizontal: 18)
        )
    }
    
    // MARK: Layout
    
    private func setupLayout() { self.snp.makeConstraints { $0.height.equalTo(90) } }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(collectionView: self) {
            collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyPreferredCell.id,
                for: indexPath
            ) as? MyPreferredCell else { return .init() }
            
            cell.configure(with: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
