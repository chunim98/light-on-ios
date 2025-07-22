//
//  NMFMapChangedReason.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//


enum NMFMapChangedReason: Int {
    /// 개발자가 API 호출로 카메라를 움직임
    case developer = 0
    
    /// 사용자의 제스처로 카메라를 움직임
    case gesture = -1
    
    /// 사용자가 버튼을 눌러 카메라를 움직임
    case control = -2
    
    /// 위치 정보 갱신으로 카메라를 움직임
    case location = -3
    
    /// 콘텐츠 패딩 변경으로 카메라를 움직임
    case contentPadding = -4
}
