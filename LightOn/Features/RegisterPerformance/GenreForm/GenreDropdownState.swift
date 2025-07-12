//
//  GenreDropdownState.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

struct GenreDropdownState {
    let tableHidden: Bool
    let selectedGenre: GenreCellItem?
    
    func updated(
        tableHidden: Bool? = nil,
        selectedGenre: GenreCellItem?? = nil
    ) -> GenreDropdownState {
        GenreDropdownState(
            tableHidden: tableHidden ?? self.tableHidden,
            selectedGenre: selectedGenre ?? self.selectedGenre
        )
    }
}
