//
//  AddressFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

import Foundation
import Combine

final class AddressFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let provinceTap: AnyPublisher<Void, Never>
        let cityTap: AnyPublisher<Void, Never>
        let selectedProvince: AnyPublisher<Province, Never>
        let selectedCity: AnyPublisher<City, Never>
    }
    struct Output {
        /// 광역 단위 배열
        let provinces: AnyPublisher<[Province], Never>
        /// 도시 단위 배열
        let cities: AnyPublisher<[City], Never>
        /// 주소 폼 상태
        let state: AnyPublisher<AddressFormState, Never>
        /// 선택한 지역 아이디
        let regionID: AnyPublisher<Int?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let addressRepo = AddressRepo()
    private let updateAddressFormStateUC = UpdateAddressFormStateUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<AddressFormState, Never>(.init(
            provinceSelection: nil,
            citySelection: nil,
            style: .allClosed
        ))
        
        let provinces = addressRepo.getProvinces()
        let cities = addressRepo.getCities(
            selectedProvince: input.selectedProvince
        )
        
        updateAddressFormStateUC.execute(
            provinceTap: input.provinceTap,
            cityTap: input.cityTap,
            selectedProvince: input.selectedProvince,
            selectedCity: input.selectedCity,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        let regionID = stateSubject
            .map { $0.citySelection?.id }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(
            provinces: provinces,
            cities: cities,
            state: stateSubject.eraseToAnyPublisher(),
            regionID: regionID
        )
    }
}
