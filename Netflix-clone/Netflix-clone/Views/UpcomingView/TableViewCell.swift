//
//  TableViewCell.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/25.
//

import UIKit
import SnapKit
import Alamofire

class TableViewCell: UITableViewCell {

    // MARK: - Stored-Prop
    static let identifier: String = "TableViewCell"    //  -> Singleton

    // MARK: - Custom Views
    private let posterImageView: UIImageView = {

        let imageView: UIImageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
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
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }

    public func configure(with model: TMDBMoviesResponse.TMDBMovie) -> Void {

        let baseImageURL: String = "https://image.tmdb.org/t/p/w500"

        guard let url: URL = URL(string: "\(baseImageURL)\(model.poster_path ?? "")") else { return }

        AF.request(url)
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case .success(let data):
                    if let safeData: Data = data {
                        DispatchQueue.main.async { [weak self] in
                            self?.posterImageView.image = UIImage(data: safeData)
                            self?.titleLabel.text = model.title
                        }
                    }
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    break;
                }
            }
    }
}
