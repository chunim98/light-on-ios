//
//  PopularSectionCollectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

final class PopularSectionCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias Item = LargeEventCardItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Properties
    
    private var diffableDataSource: DataSource?

    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        setupDefaults()
        setupDiffableDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        register(
            LargeEventCardCell.self,
            forCellWithReuseIdentifier: LargeEventCardCell.id
        )
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        setFixedLayout(
            fixedSize: CGSize(width: 278, height: 230.17),
            spacing: 12,
            sectionInset: .init(horizontal: 18, vertical: 8)
        )
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(collectionView: self) {
            collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LargeEventCardCell.id,
                for: indexPath
            ) as? LargeEventCardCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}
