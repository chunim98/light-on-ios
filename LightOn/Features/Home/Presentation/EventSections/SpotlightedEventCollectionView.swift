//
//  SpotlightedEventCollectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

final class SpotlightedEventCollectionView<Item: MediumEventCardItem>: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Properties
    
    private var diffableDataSource: DataSource?

    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        setupDefaults()
        configureDiffableDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func setupDefaults() {
        register(
            MediumEventCardCollectionCell.self,
            forCellWithReuseIdentifier: MediumEventCardCollectionCell.id
        )
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        setFixedLayout(
            fixedSize: CGSize(width: 330, height: 104),
            spacing: 12,
            sectionInset: .init(horizontal: 18, vertical: 8)
        )
    }
    
    private func configureDiffableDataSource() {
        diffableDataSource = DataSource(collectionView: self) {
            collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MediumEventCardCollectionCell.id,
                for: indexPath
            ) as? MediumEventCardCollectionCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    func applySnapshot(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}
