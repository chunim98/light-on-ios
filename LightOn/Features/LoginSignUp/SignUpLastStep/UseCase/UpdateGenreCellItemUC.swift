//
//  UpdateGenreCellItemUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

final class UpdateGenreCellItemUC {
    /// 선택된 셀의 상태를 업데이트
    func execute(
        selectedItem: AnyPublisher<GenreCellItem, Never>,
        genreItems: AnyPublisher<[GenreCellItem], Never>
    ) -> AnyPublisher<[GenreCellItem], Never> {
        selectedItem.withLatestFrom(genreItems) { selected, items in
            items.map { $0.id == selected.id ? $0.toggleSelected() : $0 }
        }
    }
}
