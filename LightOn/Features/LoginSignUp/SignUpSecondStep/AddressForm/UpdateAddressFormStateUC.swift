//
//  UpdateAddressFormStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//

import Combine

final class UpdateAddressFormStateUC {
    /// 주소 폼 상태 업데이트
    func execute(
        provinceTap: AnyPublisher<Void, Never>,
        cityTap: AnyPublisher<Void, Never>,
        selectedProvince: AnyPublisher<Province, Never>,
        selectedCity: AnyPublisher<City, Never>,
        state: AnyPublisher<AddressFormState, Never>
    ) -> AnyPublisher<AddressFormState, Never> {
        Publishers.MergeMany(
            // 광역 단위 버튼 탭
            provinceTap.withLatestFrom(state) {
                $1.updated(style: .provinceOpen)
            },
            
            // 도시 단위 버튼 탭
            cityTap.withLatestFrom(state) {
                $1.updated(style: .cityOpen)
            },
            
            // 광역 단위 선택
            selectedProvince.withLatestFrom(state) {
                $1.updated(
                    provinceSelection: $0,
                    citySelection: .some(nil),
                    style: .allClosed
                )
            },
            
            // 도시 단위 탭
            selectedCity.withLatestFrom(state) {
                $1.updated(citySelection: $0, style: .allClosed)
            }
        )
        .eraseToAnyPublisher()
    }
}
