//
//  DataRequest+.swift
//  LightOn
//
//  Created by 신정욱 on 8/3/25.
//

import Foundation

import Alamofire

extension DataRequest {
    /// 리스폰스 파싱
    func decodeResponse<ResponseDTO: Decodable>(
        decodeType: ResponseDTO.Type,
        completion: @escaping (ResponseDTO) -> Void,
        errorHandler: ((APIErrorDTO) -> Void)? = nil
    ) {
        // validate없이는 Authenticator.didRequest 호출 안 됨
        self.validate().responseDecodable(
            of: APIResultObjectDTO<ResponseDTO>.self
        ) { response in
            switch response.result {
            case .success(let resultDTO):
                resultDTO.response.map { completion($0) }
                
            case .failure(_):
                guard let data = response.data else { return }
                
                let resultDTO = try? JSONDecoder().decode(
                    APIResultObjectDTO<ResponseDTO>.self,
                    from: data
                )
                
                resultDTO?.error.map { errorHandler?($0) }
            }
        }
    }
}
