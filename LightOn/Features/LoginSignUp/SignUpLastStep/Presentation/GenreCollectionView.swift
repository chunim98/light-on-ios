//
//  GenreCollectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

final class GenreCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, GenreCellItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GenreCellItem>
    
    // MARK: Properties
    
    private(set) var diffableDataSource: DataSource?

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
        register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.id)
        backgroundColor = .clear
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0 // 스크롤 방향 기준 아이템 간 간격
        flowLayout.minimumLineSpacing = 30     // 스크롤 방향 기준 열 간격
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .init(horizontal: 24)
        flowLayout.itemSize = CGSize(width: 101, height: 101)
        
        collectionViewLayout = flowLayout
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(collectionView: self) {
            collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenreCell.id,
                for: indexPath
            ) as? GenreCell else { return .init() }
            
            cell.configure(item)
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


