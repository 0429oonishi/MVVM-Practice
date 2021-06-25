//
//  ArticleViewModel.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/25.
//

import Foundation

final class ArticleViewModel {
    
    var articles = [Article]() {
        didSet {
            reloadHandler?()
        }
    }
    var reloadHandler: (() -> Void)?
    
    func fetchArticles() {
        let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=20")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                fatalError("\(error)")
            }
            guard let data = data else { return }
            do {
                let articles = try JSONDecoder().decode([Article].self, from: data)
                self.articles = articles
            } catch {
                fatalError("\(error)")
            }
        }
        task.resume()
    }
    
}
