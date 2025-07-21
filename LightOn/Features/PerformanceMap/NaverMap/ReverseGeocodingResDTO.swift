//
//  ReverseGeocodingResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//


struct ReverseGeocodingResDTO: Decodable {
    let status: Status
    let results: [Result]
    
    /// 동 이름 추출
    func getDongName() -> String? { results.first?.region.area3.name }
    
    struct Status: Decodable {
        let code: Int
        let name: String
        let message: String
    }
    
    struct Result: Decodable {
        let name: String
        let code: Code
        let region: Region
        let land: Land?
        
        struct Code: Decodable {
            let id: String
            let type: String
            let mappingId: String
        }
        
        struct Region: Decodable {
            let area0: Area
            let area1: Area
            let area2: Area
            let area3: Area
            let area4: Area
            
            struct Area: Decodable {
                let name: String
                let coords: Coords
                
                struct Coords: Decodable {
                    let center: Center
                    
                    struct Center: Decodable {
                        let crs: String
                        let x: Double
                        let y: Double
                    }
                }
            }
        }
        
        struct Land: Decodable {
            let type: String
            let number1: String
            let number2: String
            let name: String?
            let coords: Region.Area.Coords
            let addition0: Addition
            let addition1: Addition
            let addition2: Addition
            let addition3: Addition
            let addition4: Addition
            
            struct Addition: Decodable {
                let type: String
                let value: String
            }
        }
    }
}
