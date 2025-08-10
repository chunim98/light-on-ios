//
//  MapFilterView.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

import SwiftUI
import Combine

struct MapFilterView: View {
    
    // MARK: Properties
    
    @ObservedObject var vm: MapFilterVM
    
    // MARK: Initializer
    
    init(vm: MapFilterVM) { self.vm = vm }
    
    // MARK: Views
    
    /// 태그들을 담는 스택
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 6) {
                ForEach(vm.state.items, id: \.tagType) { tagButton(item: $0) }
            }
            .padding(.horizontal, 18)
        }
    }
    
    /// 태그 버튼
    private func tagButton(item: MapFilterTagItem) -> some View {
        Button {
            vm.intent.send(.tagTap(item.tagType))
            
        } label: {
            Text(item.title)
                .foregroundStyle(Color(item.style.foregroundColor))
                .font(Font(UIFont.pretendard.semiBold(14)))
        }
        .padding(.horizontal, 12)
        .frame(height: 29)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(item.style.backgroundColor))
                .strokeBorder(Color(item.style.strokeColor), lineWidth: 1)
        }
    }
}

// MARK: Binders & Publishers

extension MapFilterView {
    /// 선택된 필터 퍼블리셔
    var filterPublisher: AnyPublisher<MapFilterType?, Never> {
        vm.$state
            .map { $0.items.first(where: { $0.isSelected })?.tagType }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    MapFilterView(vm: .init())
}
