//
//  AddressRepo.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

import Combine

final class AddressRepo {
    /// 광역 단위 아이템들 반환
    func getProvinces() -> AnyPublisher<[Province], Never> {
        Just(Province.allCases).eraseToAnyPublisher()
    }
    
    /// 도시 단위 아이템들 반환
    func getCities(
        selectedProvince: AnyPublisher<Province, Never>
    ) -> AnyPublisher<[City], Never> {
        selectedProvince
            .compactMap { City.cities[$0] }
            .eraseToAnyPublisher()
    }
}
