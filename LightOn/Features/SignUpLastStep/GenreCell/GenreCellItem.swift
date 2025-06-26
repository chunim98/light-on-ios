//
//  GenreCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

struct GenreCellItem: Hashable {
    let thumbnailImage: UIImage
    let genreText: String
    var isSelected: Bool = false
    
    static let mocks: [GenreCellItem] = [
        .init(thumbnailImage: .debugBusking, genreText: "J-Pop", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "JAZZ", isSelected: true),
        .init(thumbnailImage: .debugBusking, genreText: "ROCK", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "HIPHOP", isSelected: true),
        .init(thumbnailImage: .debugBusking, genreText: "CLASSIC", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "BALLAD", isSelected: false),
        .init(thumbnailImage: .debugBusking, genreText: "EDM", isSelected: true),
        .init(thumbnailImage: .debugBusking2, genreText: "FOLK", isSelected: false),
        .init(thumbnailImage: .debugBusking, genreText: "INDIE", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "BLUES", isSelected: true),
        .init(thumbnailImage: .debugBusking, genreText: "COUNTRY", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "R&B", isSelected: false),
        .init(thumbnailImage: .debugBusking, genreText: "REGGAE", isSelected: true),
        .init(thumbnailImage: .debugBusking2, genreText: "TROT", isSelected: false),
        .init(thumbnailImage: .debugBusking, genreText: "METAL", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "TECHNO", isSelected: true),
        .init(thumbnailImage: .debugBusking, genreText: "ACOUSTIC", isSelected: false),
        .init(thumbnailImage: .debugBusking2, genreText: "WORLD", isSelected: false)
    ]
}
