//
//  RegisterBuskingInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//


struct RegisterBuskingInfo {
    var name: String?
    var description: String?
    var regionID: Int?
    var detailAddress: String?
    var notice: String?
    var genre: [String] = []
    var posterPath: String?
    var startDate: String?      // yyyy-MM-dd
    var endDate: String?        // yyyy-MM-dd
    var startTime: String?      // "HH:mm"
    var endTime: String?        // "HH:mm"
    var documentPath: String?   // 증빙자료 URL
    var artistName: String?
    var artistDescription: String?
}
