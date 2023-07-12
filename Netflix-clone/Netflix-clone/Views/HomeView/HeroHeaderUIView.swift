//
//  HeroHeaderUIView.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/13.
//

import UIKit
import Combine

class HeroHeaderUIView: UIView {
    
    // MARK: - Stored-Prop
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

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
    
    private lazy var heroImageViewCombine: UIImageView = {
       
        let imageView: UIImageView = UIImageView()
        
        APICaller.shared.fetchHeroImageWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                //  Error Handling
                if case let .failure(error) = completion {
                    
                    APICaller.APIError.failedFetchData
                    print("Fetch Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak imageView] heroImage in
                
                imageView?.image = heroImage
                imageView?.contentMode = .scaleAspectFit
                imageView?.clipsToBounds = true
            }.store(in: &cancellables)
        
        return imageView
    }()
    
    private let playButton: UIButton = {
        
        let button: UIButton = UIButton()
        
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let downloadButton: UIButton = {
        
        let button: UIButton = UIButton()
        
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let playButtonConstraints: [NSLayoutConstraint] = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonConstraints: [NSLayoutConstraint] = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: MovieViewModel) -> Void {
        
        let baseImageURL: String = "https://image.tmdb.org/t/p/w500"
        
        guard let url: URL = URL(string: "\(baseImageURL)\(model.posterURL)") else { return }
        
        heroImageView.sd_setImage(with: url)
    }
}
