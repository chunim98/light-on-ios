//
//  APIConstants.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

import Foundation

struct APIConstants {
    static let naverMapClientID     = Bundle.main.infoDictionary?["NMFNcpKeyId"] as! String
    static let naverMapClientSecret = Bundle.main.infoDictionary?["NMFNcpKey"] as! String
}

// MARK: Global Properties

let BaseURL = Bundle.main.infoDictionary?["LightOnRootURL"] as! String
