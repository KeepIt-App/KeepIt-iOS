//
//  SettingTableData.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/12.
//

import Foundation

struct SettingTableData {

    static var instance = SettingTableData()

    let tableData = [["KeepIt!", "버전"], ["이메일 보내기"]]
    let tableSubData = [["","1.0"], ["개발자에게 이메일을 전송합니다"]]
    let sectionData = ["앱 정보", "피드백"]
}
