//
//  AddressRepo.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

final class AddressRepo {
    
    // MARK: Province
    
    /// 광역단위
    enum Province: String, CaseIterable, Hashable {
        case seoul      = "서울특별시"
        case busan      = "부산광역시"
        case daegu      = "대구광역시"
        case incheon    = "인천광역시"
        case gwangju    = "광주광역시"
        case daejeon    = "대전광역시"
        case ulsan      = "울산광역시"
        case sejong     = "세종특별자치시"
        case gyeonggi   = "경기도"
        case gangwon    = "강원특별자치도"
        case chungbuk   = "충청북도"
        case chungnam   = "충청남도"
        case jeonbuk    = "전라북도"
        case jeonnam    = "전라남도"
        case gyeongbuk  = "경상북도"
        case gyeongnam  = "경상남도"
        case jeju       = "제주특별자치도"
    }
    
    // MARK: City
    
    struct City {
        let id: Int
        let name: String
    }
    
    // MARK: Properties
    
    let provinces = Province.allCases
    let cities: [Province: [City]] = [
        // 서울특별시
        .seoul: [
            City(id: 101, name: "종로구"), City(id: 102, name: "중구"), City(id: 103, name: "용산구"),
            City(id: 104, name: "성동구"), City(id: 105, name: "광진구"), City(id: 106, name: "동대문구"),
            City(id: 107, name: "중랑구"), City(id: 108, name: "성북구"), City(id: 109, name: "강북구"),
            City(id: 110, name: "도봉구"), City(id: 111, name: "노원구"), City(id: 112, name: "은평구"),
            City(id: 113, name: "서대문구"), City(id: 114, name: "마포구"), City(id: 115, name: "양천구"),
            City(id: 116, name: "강서구"), City(id: 117, name: "구로구"), City(id: 118, name: "금천구"),
            City(id: 119, name: "영등포구"), City(id: 120, name: "동작구"), City(id: 121, name: "관악구"),
            City(id: 122, name: "서초구"), City(id: 123, name: "강남구"), City(id: 124, name: "송파구"),
            City(id: 125, name: "강동구")
        ],
        
        // 부산광역시
        .busan: [
            City(id: 201, name: "중구"), City(id: 202, name: "서구"), City(id: 203, name: "동구"),
            City(id: 204, name: "영도구"), City(id: 205, name: "부산진구"), City(id: 206, name: "동래구"),
            City(id: 207, name: "남구"), City(id: 208, name: "북구"), City(id: 209, name: "해운대구"),
            City(id: 210, name: "사하구"), City(id: 211, name: "금정구"), City(id: 212, name: "연제구"),
            City(id: 213, name: "수영구"), City(id: 214, name: "사상구"), City(id: 215, name: "기장군")
        ],
        
        // 대구광역시
        .daegu: [
            City(id: 301, name: "중구"), City(id: 302, name: "동구"), City(id: 303, name: "서구"),
            City(id: 304, name: "남구"), City(id: 305, name: "북구"), City(id: 306, name: "수성구"),
            City(id: 307, name: "달서구"), City(id: 308, name: "달성군")
        ],
        
        // 인천광역시
        .incheon: [
            City(id: 401, name: "중구"), City(id: 402, name: "동구"), City(id: 403, name: "서구"),
            City(id: 404, name: "미추홀구"), City(id: 405, name: "연수구"), City(id: 406, name: "남동구"),
            City(id: 407, name: "부평구"), City(id: 408, name: "계양구"), City(id: 409, name: "서구"),
            City(id: 410, name: "강화군"), City(id: 411, name: "옹진군")
        ],
        
        // 광주광역시
        .gwangju: [
            City(id: 501, name: "동구"), City(id: 502, name: "서구"), City(id: 503, name: "남구"),
            City(id: 504, name: "북구"), City(id: 505, name: "광산구")
        ],
        
        // 대전광역시
        .daejeon: [
            City(id: 601, name: "동구"), City(id: 602, name: "중구"), City(id: 603, name: "서구"),
            City(id: 604, name: "유성구"), City(id: 605, name: "대덕구")
        ],
        
        // 울산광역시
        .ulsan: [
            City(id: 701, name: "중구"), City(id: 702, name: "남구"), City(id: 703, name: "동구"),
            City(id: 704, name: "북구"), City(id: 705, name: "울주군")
        ],
        
        // 세종특별자치시
        .sejong: [
            City(id: 801, name: "세종시")
        ],
        
        // 경기도
        .gyeonggi: [
            City(id: 901, name: "수원시"), City(id: 902, name: "성남시"), City(id: 903, name: "고양시"),
            City(id: 904, name: "용인시"), City(id: 905, name: "부천시"), City(id: 906, name: "안산시"),
            City(id: 907, name: "안양시"), City(id: 908, name: "남양주시"), City(id: 909, name: "화성시"),
            City(id: 910, name: "평택시"), City(id: 911, name: "의정부시"), City(id: 912, name: "시흥시"),
            City(id: 913, name: "파주시"), City(id: 914, name: "김포시"), City(id: 915, name: "광명시"),
            City(id: 916, name: "군포시"), City(id: 917, name: "이천시"), City(id: 918, name: "오산시"),
            City(id: 919, name: "하남시"), City(id: 920, name: "의왕시"), City(id: 921, name: "양주시"),
            City(id: 922, name: "구리시"), City(id: 923, name: "안성시"), City(id: 924, name: "포천시"),
            City(id: 925, name: "광주시"), City(id: 926, name: "동두천시"), City(id: 927, name: "양평군"),
            City(id: 928, name: "여주시"), City(id: 929, name: "가평군"), City(id: 930, name: "연천군")
        ],
        
        // 강원특별자치도
        .gangwon: [
            City(id: 1001, name: "춘천시"), City(id: 1002, name: "원주시"), City(id: 1003, name: "강릉시"),
            City(id: 1004, name: "동해시"), City(id: 1005, name: "태백시"), City(id: 1006, name: "속초시"),
            City(id: 1007, name: "삼척시"), City(id: 1008, name: "홍천군"), City(id: 1009, name: "횡성군"),
            City(id: 1010, name: "영월군"), City(id: 1011, name: "평창군"), City(id: 1012, name: "정선군"),
            City(id: 1013, name: "철원군"), City(id: 1014, name: "화천군"), City(id: 1015, name: "양구군"),
            City(id: 1016, name: "인제군"), City(id: 1017, name: "고성군"), City(id: 1018, name: "양양군")
        ],
        
        // 충청북도
        .chungbuk: [
            City(id: 1101, name: "청주시"), City(id: 1102, name: "충주시"), City(id: 1103, name: "제천시"),
            City(id: 1104, name: "보은군"), City(id: 1105, name: "옥천군"), City(id: 1106, name: "영동군"),
            City(id: 1107, name: "진천군"), City(id: 1108, name: "괴산군"), City(id: 1109, name: "음성군"),
            City(id: 1110, name: "단양군"), City(id: 1111, name: "증평군")
        ],
        
        // 충청남도
        .chungnam: [
            City(id: 1201, name: "천안시"), City(id: 1202, name: "공주시"), City(id: 1203, name: "보령시"),
            City(id: 1204, name: "아산시"), City(id: 1205, name: "서산시"), City(id: 1206, name: "논산시"),
            City(id: 1207, name: "계룡시"), City(id: 1208, name: "당진시"), City(id: 1209, name: "금산군"),
            City(id: 1210, name: "부여군"), City(id: 1211, name: "서천군"), City(id: 1212, name: "청양군"),
            City(id: 1213, name: "홍성군"), City(id: 1214, name: "예산군"), City(id: 1215, name: "태안군")
        ],
        
        // 전라북도
        .jeonbuk: [
            City(id: 1301, name: "전주시"), City(id: 1302, name: "군산시"), City(id: 1303, name: "익산시"),
            City(id: 1304, name: "정읍시"), City(id: 1305, name: "남원시"), City(id: 1306, name: "김제시"),
            City(id: 1307, name: "완주군"), City(id: 1308, name: "진안군"), City(id: 1309, name: "무주군"),
            City(id: 1310, name: "장수군"), City(id: 1311, name: "임실군"), City(id: 1312, name: "순창군"),
            City(id: 1313, name: "고창군"), City(id: 1314, name: "부안군")
        ],
        
        // 전라남도
        .jeonnam: [
            City(id: 1401, name: "목포시"), City(id: 1402, name: "여수시"), City(id: 1403, name: "순천시"),
            City(id: 1404, name: "나주시"), City(id: 1405, name: "광양시"), City(id: 1406, name: "담양군"),
            City(id: 1407, name: "곡성군"), City(id: 1408, name: "구례군"), City(id: 1409, name: "고흥군"),
            City(id: 1410, name: "보성군"), City(id: 1411, name: "화순군"), City(id: 1412, name: "장흥군"),
            City(id: 1413, name: "강진군"), City(id: 1414, name: "해남군"), City(id: 1415, name: "영암군"),
            City(id: 1416, name: "무안군"), City(id: 1417, name: "함평군"), City(id: 1418, name: "영광군"),
            City(id: 1419, name: "장성군"), City(id: 1420, name: "완도군"), City(id: 1421, name: "진도군"),
            City(id: 1422, name: "신안군")
        ],
        
        // 경상북도
        .gyeongbuk: [
            City(id: 1501, name: "포항시"), City(id: 1502, name: "경주시"), City(id: 1503, name: "김천시"),
            City(id: 1504, name: "안동시"), City(id: 1505, name: "구미시"), City(id: 1506, name: "영주시"),
            City(id: 1507, name: "영천시"), City(id: 1508, name: "상주시"), City(id: 1509, name: "문경시"),
            City(id: 1510, name: "경산시"), City(id: 1511, name: "의성군"), City(id: 1512, name: "청송군"),
            City(id: 1513, name: "영양군"), City(id: 1514, name: "영덕군"), City(id: 1515, name: "청도군"),
            City(id: 1516, name: "고령군"), City(id: 1517, name: "성주군"), City(id: 1518, name: "칠곡군"),
            City(id: 1519, name: "예천군"), City(id: 1520, name: "봉화군"), City(id: 1521, name: "울진군"),
            City(id: 1522, name: "울릉군")
        ],
        
        // 경상남도
        .gyeongnam: [
            City(id: 1601, name: "창원시"), City(id: 1602, name: "진주시"), City(id: 1603, name: "통영시"),
            City(id: 1604, name: "사천시"), City(id: 1605, name: "김해시"), City(id: 1606, name: "밀양시"),
            City(id: 1607, name: "거제시"), City(id: 1608, name: "양산시"), City(id: 1609, name: "의령군"),
            City(id: 1610, name: "함안군"), City(id: 1611, name: "창녕군"), City(id: 1612, name: "고성군"),
            City(id: 1613, name: "남해군"), City(id: 1614, name: "하동군"), City(id: 1615, name: "산청군"),
            City(id: 1616, name: "함양군"), City(id: 1617, name: "거창군"), City(id: 1618, name: "합천군")
        ],
        
        // 제주특별자치도
        .jeju: [
            City(id: 1701, name: "제주시"), City(id: 1702, name: "서귀포시")
        ]
    ]
}
