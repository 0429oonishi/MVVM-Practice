//
//  Article.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/25.
//

import Foundation

struct Article: Decodable {
    let title: String

    init(dic: [String: Any]) {
        title = dic["title"] as? String ?? ""
    }
    
}
