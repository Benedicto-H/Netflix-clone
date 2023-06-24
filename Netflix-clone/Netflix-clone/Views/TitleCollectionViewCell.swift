//
//  TitleCollectionViewCell.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/21.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Stored-Prop  (-> Singleton)
    static let identifier: String = "TitleCollectionViewCell"
    
    // MARK: - Custom View
    private let posterImageView: UIImageView = {
       
        let imageView: UIImageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) -> Void {
        
        let imageURLPath: String = "https://image.tmdb.org/t/p/w500"
        
        guard let url: URL = URL(string: "\(imageURLPath)\(model)") else { return }
        
        posterImageView.sd_setImage(with: url)
    }
}
