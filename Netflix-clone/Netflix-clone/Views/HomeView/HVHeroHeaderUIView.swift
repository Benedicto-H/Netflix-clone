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
        HVHeroHeaderUIView.fetchHeroImage(completionHandler: { img in
            
            imageView.image = img
        })
        
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
    
    //  Fetch temp HeroHeaderImage with completionHandler (-> for Test)
    private static func fetchHeroImage(completionHandler: @escaping (UIImage) -> Void) -> Void {
        
        let originURL: String = "https://occ-0-988-1360.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABX4VbDY-FqCITdF33xEJcP7vZQxu0MLlvhkOTyuEsU4yqZK7NRYb91sHwxmjtXlgxX11NuDB9DgHW0pOLfToPms_n75E6VkDOv3Y.jpg?r=9e3" //  source: https://www.netflix.com/kr/title/81005126
        
        guard let url: URL = URL(string: originURL) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let heroHeaderImage: UIImage? = UIImage(data: safeData)
                
                DispatchQueue.main.async {
                    
                    completionHandler(heroHeaderImage ?? UIImage())
                }
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
}
