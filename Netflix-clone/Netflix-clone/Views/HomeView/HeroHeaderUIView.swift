//
//  HeroHeaderUIView.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/13.
//

import UIKit
import SnapKit

class HeroHeaderUIView: UIView {

    // MARK: - Custom Views
    private let heroImageView: UIImageView = {
        
        let imageView: UIImageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        APICaller.shared.fetchHeroImage { heroImage in
            imageView.image = heroImage
        }
        
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
        
        let button: UIButton = UIButton()
        
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        
        let button: UIButton = UIButton()
        
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()
        
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {    //  NSCoding - (Required) Method
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        //  이 시점에서 Safe Area의 영향을 받음.
        
        heroImageView.frame = bounds
    }
    
    private func addGradient() -> Void {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() -> Void {
        
        playButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.leading.equalToSuperview().inset(70)
            make.bottom.equalToSuperview().inset(50)
            /// .inset(_ amount:)   =>  상대적 위치
            /// .offset(_ amount:)  =>  절대적 위치
        }
        
        downloadButton.snp.makeConstraints { make in
            make.width.height.equalTo(playButton)
            make.trailing.equalToSuperview().inset(70)
            make.bottom.equalTo(playButton.snp.bottom)
        }
    }
    
    public func configure(with model: MovieViewModel) -> Void {
        
        let baseImageURL: String = "https://image.tmdb.org/t/p/w500"
        
        guard let url: URL = URL(string: "\(baseImageURL)\(model.posterURL)") else { return }
        
        heroImageView.sd_setImage(with: url)
    }
}
