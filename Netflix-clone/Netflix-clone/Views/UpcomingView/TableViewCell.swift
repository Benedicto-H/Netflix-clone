//
//  TableViewCell.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/25.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {

    // MARK: - Stored-Prop
    static let identifier: String = "TableViewCell"    //  -> Singleton
    
    // MARK: - Custom Views
    private let posterImageView: UIImageView = {
        
        let imageView: UIImageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        
        let label: UILabel = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        //  label.lineBreakMode = .byWordWrapping
        //  label.numberOfLines = 0
        
        return label
    }()
    
    private let playButton: UIButton = {
        
        let button: UIButton = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        return button
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func applyConstraints() -> Void {
        
        let posterImageViewConstraints: [NSLayoutConstraint] = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playButtonConstraints: [NSLayoutConstraint] = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    public func configureTableViewCell(with model: TMDBMoviesResponse.TMDBMovie) -> Void {
        
        let baseImageURL: String = "https://image.tmdb.org/t/p/w500"
        
        guard let url: URL = URL(string: "\(baseImageURL)\(model.poster_path ?? "")") else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.posterImageView.sd_setImage(with: url)
            self?.titleLabel.text = model.original_title ?? ""
        }
    }
}
