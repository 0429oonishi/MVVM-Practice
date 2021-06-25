//
//  Article.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/25.
//

import Foundation

struct Article: Decodable {
    let title: String

    init(json: [String: Any]) {
        title = json["title"] as? String ?? ""
    }
    
}
