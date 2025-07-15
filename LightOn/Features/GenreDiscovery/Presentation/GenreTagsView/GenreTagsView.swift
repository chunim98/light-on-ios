//
//  GenreTagsView.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import SwiftUI
import Combine

struct GenreTagsView: View {
    
    // MARK: Properties
    
    @ObservedObject var vm: GenreTagsVM
    
    // MARK: Initializer
    
    init(vm: GenreTagsVM) {
        self.vm = vm
    }
    
    // MARK: Views
    
    /// 태그들을 담는 스택
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 6) {
                ForEach(vm.state.items, id: \.tag) { tagButton(item: $0) }
            }
            .padding(.horizontal, 18)
        }
    }

    /// 태그 버튼
    private func tagButton(item: GenreTagItem) -> some View {
        Button {
            vm.intent.send(.buttonTap(item.tag))
            
        } label: {
            Text(item.title)
                .foregroundStyle(Color(item.style.foregroundColor))
                .font(Font(item.style.font))
            
        }
        .padding(.horizontal, 12)
        .frame(height: 30)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color(item.style.strokeColor), lineWidth: 1)
                .fill(Color(item.style.backgroundColor))
        }
    }
}

// MARK: Binders & Publishers

extension GenreTagsView {
    /// 선택된 장르 퍼블리셔
    var selectedGenrePublisher: AnyPublisher<String, Never> {
        vm.$state
            .compactMap { $0.items.first(where: { $0.isSelected })?.title }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    GenreTagsView(vm: .init())
}
