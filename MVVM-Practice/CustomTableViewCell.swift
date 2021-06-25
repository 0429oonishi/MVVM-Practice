//
//  CustomTableViewCell.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/25.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        
    }
    
    func configure(article: Article) {
        titleLabel.text = article.title
    }
    
}
