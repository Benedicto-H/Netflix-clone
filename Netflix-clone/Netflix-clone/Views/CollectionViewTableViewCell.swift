//
//  CollectionViewTableViewCell.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/11.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    // MARK: - Stored-Prop (-> Singleton)
    static let identifier: String = "CollectionViewTableViewCell"
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        
        fatalError()
    }

}
