//
//  RegisterBuskingInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit

struct RegisterBuskingInfo {
    var name: String?
    var description: String?
    var regionID: Int?
    var detailAddress: String?
    var notice: String?
    var genre: [String] = []
    var posterInfo: ImageInfo?
    var startDate: String?          // yyyy-MM-dd
    var endDate: String?            // yyyy-MM-dd
    var startTime: String?          // "HH:mm"
    var endTime: String?            // "HH:mm"
    var documentInfo: ImageInfo?
    var artistName: String?
    var artistDescription: String?
    
    /// 모든 필드가 유효한지 여부
    var allValuesValid: Bool {
        name              != nil &&
        description       != nil &&
        regionID          != nil &&
        detailAddress     != nil &&
        notice            != nil &&
        posterInfo        != nil &&
        startDate         != nil &&
        endDate           != nil &&
        startTime         != nil &&
        endTime           != nil &&
        documentInfo      != nil &&
        artistName        != nil &&
        artistDescription != nil &&
        !genre.isEmpty
    }
}
