//
//  EditBuskingUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/23/25.
//

import UIKit
import Combine

final class EditBuskingUC {
    
    private let repo: EditBuskingRepo
    
    init(repo: EditBuskingRepo) {
        self.repo = repo
    }
    
    /// 버스킹 수정 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        id: Int,
        info: AnyPublisher<BuskingInfo, Never>
    ) -> AnyPublisher<Void, Never> {
        trigger
            .withLatestFrom(info) { _, info in info }
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .compactMap { [weak self] info in
                guard let self else { return AnyPublisher<Void, Never>?.none }
                
                let posterData = info.posterInfo.flatMap { self.resizeImage($0.image) }
                let documentData = info.documentInfo.flatMap { self.resizeImage($0.image) }
                
                return repo.requestEditBusking(
                    id: id,
                    info: info,
                    posterData: posterData,
                    documentData: documentData
                )
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
    
    // MARK: Private Helper
    
    /// 이미지 리사이징 후 png 데이터로 변환
    private func resizeImage(_ image: UIImage) -> Data? {
        let maxBytes = Int(7.5*1024*1024)  // 목표 용량 7.5MB
        var bestData: Data?
        var start: CGFloat = 0
        var end: CGFloat = 1
        
        while start <= end {
            let mid = (start+end) / 2
            
            guard let imageData = image.resizeImage(
                newWidth: image.size.width*mid
            ).pngData()
            else { break }
            
            if imageData.count < maxBytes {
                bestData = imageData
                start = mid + 0.01
                
            } else {
                end = mid - 0.01
            }
        }
        
        return bestData
    }
}
