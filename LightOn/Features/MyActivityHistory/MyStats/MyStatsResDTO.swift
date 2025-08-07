//
//  MyStatsResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//


struct MyStatsResDTO: Decodable {
    let totalPerformances: Int
    let mostPreferredRegion: String
}

// MARK: Mapper

extension MyStatsResDTO {
#warning("이름 사용하는지 확인 필요")
    func toDomain() -> MyStatsInfo {
        MyStatsInfo(
            name: "아이유",
            applyCount: totalPerformances,
            place: mostPreferredRegion
        )
    }
}
