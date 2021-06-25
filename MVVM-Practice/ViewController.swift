//
//  ViewController.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/25.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let articleViewModel = ArticleViewModel()
    private var articles: [Article] {
        return articleViewModel.articles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
        articleViewModel.fetchArticles()
        
    }
    
    private func setupViewModel() {
        articleViewModel.reloadHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.nib,
                           forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier
        ) as! CustomTableViewCell
        let article = articles[indexPath.row]
        cell.configure(article: article)
        return cell
    }
    
    
}



