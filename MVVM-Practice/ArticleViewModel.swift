//
//  ArticleViewModel.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/25.
//

import Foundation

final class ArticleViewModel {
    
    var articles = [Article]()
    
    func fetchArticles() {
        guard let url: URL = URL(string: "http://qiita.com/api/v2/items") else { return }
        let task: URLSessionTask  = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                guard let data = data,
                      let jsonArray = try JSONSerialization.jsonObject(
                        with: data,
                        options: JSONSerialization.ReadingOptions.allowFragments
                      ) as? [Any] else { return }
                let articlesJson = jsonArray.compactMap { json in
                    return json as? [String: Any]
                }
                let articles = articlesJson.map { articleJson in
                    return Article(json: articleJson)
                }
                DispatchQueue.main.async {
                    self.articles = articles
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
