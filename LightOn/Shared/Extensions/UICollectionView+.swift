//
//  UICollectionView+.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

extension UICollectionView {
    
    // MARK: Enum
    
    enum FittingAxis {
        case horizontal
        case vertical
    }
    
    // MARK: Methods
    
    /// viewDidLayoutSubviews 이후에 호출을 권장합니다.
    func setAspectFittingLayout(
        aspectSize: CGSize,
        itemCount: Int,
        spacing: CGFloat,
        sectionInset: UIEdgeInsets = .zero,
        fittingAxis: FittingAxis = .horizontal,
        scrollDirection: ScrollDirection = .horizontal
    ) {
        let itemCount = CGFloat(itemCount)
        
        let totalSpacing    = (itemCount-1) * spacing
        let horizontalInset = sectionInset.left + sectionInset.right
        let verticalInset   = sectionInset.top + sectionInset.bottom

        // 컬렉션 뷰 크기 기준으로 계산한, 실제 사용 가능한 최대 셀 사이즈
        let availableSize = CGSize(
            width:  (self.bounds.width-totalSpacing-horizontalInset) / itemCount,
            height: (self.bounds.height-totalSpacing-verticalInset) / itemCount
        )
        
        // 기준 축에 따라, 배율 계산하기
        let scale = fittingAxis == .horizontal ?
        availableSize.width / aspectSize.width :
        availableSize.height / aspectSize.height
        
        // 배율을 적용해 종횡비 유지하기
        let scaledSize = CGSize(
            width: aspectSize.width * scale,
            height: aspectSize.height * scale
        )
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing  = spacing // 스크롤 방향 기준 아이템 간 간격
        flowLayout.minimumLineSpacing       = spacing // 스크롤 방향 기준 열 간격
        flowLayout.scrollDirection = scrollDirection
        flowLayout.sectionInset = sectionInset
        flowLayout.itemSize = scaledSize
        
        self.collectionViewLayout = flowLayout
    }
    
    func setFixedLayout(
        fixedSize: CGSize,
        spacing: CGFloat,
        sectionInset: UIEdgeInsets = .zero,
        scrollDirection: ScrollDirection = .horizontal
    ) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing  = spacing // 스크롤 방향 기준 아이템 간 간격
        flowLayout.minimumLineSpacing       = spacing // 스크롤 방향 기준 열 간격
        flowLayout.scrollDirection = scrollDirection
        flowLayout.sectionInset = sectionInset
        flowLayout.itemSize = fixedSize
        
        self.collectionViewLayout = flowLayout
    }
}
