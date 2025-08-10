//
//  MyStatsResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//


struct MyStatsResDTO: Decodable {
    let name: String
    let totalPerformances: Int
    let mostPreferredRegion: String?
}

// MARK: Mapper

extension MyStatsResDTO {
    func toDomain() -> MyStatsInfo {
        MyStatsInfo(
            name: name,
            applyCount: totalPerformances,
            place: mostPreferredRegion ?? "없음"
        )
    }
}
