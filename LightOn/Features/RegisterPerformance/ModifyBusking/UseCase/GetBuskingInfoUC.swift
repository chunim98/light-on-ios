//
//  GetBuskingInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/23/25.
//

import Combine

final class GetBuskingInfoUC {
    
    private let repo: EditBuskingRepo
    
    init(repo: EditBuskingRepo) {
        self.repo = repo
    }
    
    /// 공연 상세정보 조회
    func execure(id: Int) -> AnyPublisher<BuskingInfo, Never> {
        repo.getBuskingInfo(id: id)
            .share()
            .eraseToAnyPublisher()
    }
}
