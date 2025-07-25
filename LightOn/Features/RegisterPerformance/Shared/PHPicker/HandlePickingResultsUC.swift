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
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let selectedImageSubject = PassthroughSubject<UIImage?, Never>()
    private let selectedFileNameSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Methods
    
    /// 선택 결과에서 이미지 추출
    func execute(
        pickingResults: AnyPublisher<[PHPickerResult], Never>
    ) -> AnyPublisher<ImageInfo?, Never> {
        pickingResults.sink { [weak self] results in
            // itemProvider는 데이터를 실제 메모리로 로드해 주는 객체
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self)
            else { self?.selectedImageSubject.send(nil); return }
            
            // 이미지 추출
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                self?.selectedImageSubject.send(image as? UIImage)
            }
            
            // 파일 이름 추출
            provider.loadFileRepresentation(
                forTypeIdentifier: UTType.image.identifier
            ) { url, _ in
                self?.selectedFileNameSubject.send(url?.lastPathComponent)
            }
        }
        .store(in: &cancellables)
        
        // 두 값 합쳐서 방출
        return Publishers.Zip(
            selectedImageSubject.eraseToAnyPublisher(),
            selectedFileNameSubject.eraseToAnyPublisher()
        )
        .map {
            guard let image = $0.0, let name = $0.1 else { return nil }
            return ImageInfo(image: image, name: name)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
