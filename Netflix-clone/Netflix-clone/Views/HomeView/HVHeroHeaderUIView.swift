//
//  HeroHeaderUIView.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/13.
//

import UIKit

class HVHeroHeaderUIView: UIView {

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
}
