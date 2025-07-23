//
//  MediumPerformanceCollectionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

import SnapKit

final class MediumPerformanceCollectionView: UICollectionView {
    
    // MARK: Enum
    
    enum Section { case main }
    
    // MARK: Typealias
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MediumPerformanceCellItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MediumPerformanceCellItem>
    
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
        register(
            MediumPerformanceCollectionCell.self,
            forCellWithReuseIdentifier: MediumPerformanceCollectionCell.id
        )
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        setFixedLayout(
            fixedSize: CGSize(width: 330, height: 104),
            spacing: 12,
            sectionInset: .init(horizontal: 18, vertical: 8)
        )
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        self.snp.makeConstraints { $0.height.equalTo(120) }
    }
    
    // MARK: DiffableDataSource
    
    private func setupDiffableDataSource() {
        diffableDataSource = DataSource(collectionView: self) {
            collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MediumPerformanceCollectionCell.id,
                for: indexPath
            ) as? MediumPerformanceCollectionCell else { return .init() }
            
            cell.configure(item: item)
            return cell
        }
    }
    
    // MARK: Public Configuration
    
    func setSnapshot(items: [MediumPerformanceCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}
