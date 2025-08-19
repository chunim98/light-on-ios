//
//  HandlePickingResultsUC.swift
//  TennisPark
//
//  Created by 신정욱 on 7/2/25.
//

import UIKit
import Combine
import PhotosUI

final class HandlePickingResultsUC {
    /// 선택 결과에서 이미지와 파일명 추출
    func execute(
        pickingResults: AnyPublisher<[PHPickerResult], Never>
    ) -> AnyPublisher<ImageInfo?, Never> {
        pickingResults.map { results -> AnyPublisher<ImageInfo?, Never> in
            // 첫 번째 결과의 itemProvider 가져오기 (이미지를 로드할 수 없는 경우 nil 방출)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self)
            else { return Just(nil).eraseToAnyPublisher() }
            
            /// 이미지 로드 퍼블리셔
            let image = Future<UIImage?, Never> { promise in
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    promise(.success(image as? UIImage))
                }
            }
            
            /// 파일 이름 로드 퍼블리셔
            let name = Future<String?, Never> { promise in
                provider.loadFileRepresentation(
                    forTypeIdentifier: UTType.image.identifier
                ) { url, _ in
                    promise(.success(url?.lastPathComponent))
                }
            }
            
            // 이미지와 파일 이름을 묶어서 ImageInfo?로 변환
            return Publishers.Zip(image, name)
                .map { image, name -> ImageInfo? in
                    guard let image, let name else { return nil }
                    return ImageInfo(image: image, name: name)
                }
                .eraseToAnyPublisher()
        }
        .switchToLatest()
        .receive(on: DispatchQueue.main) // 메인스레드 전환
        .share()
        .eraseToAnyPublisher()
    }
}
