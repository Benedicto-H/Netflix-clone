//
//  PreviewViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/11.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {

    // MARK: - Custom Views
    private let webView: WKWebView = {
       
        let webView: WKWebView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private let titleLabel: UILabel = {
       
        let label: UILabel = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Movie Title"
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
       
        let label: UILabel = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.text = "Movie Overview"
        
        return label
    }()
    
    private let downloadButton: UIButton = {
       
        let button: UIButton = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() -> Void {
        
        let webViewConstraints: [NSLayoutConstraint] = [
            //  webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), 
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let overviewLabelConstraints: [NSLayoutConstraint] = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints: [NSLayoutConstraint] = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: PreviewViewModel) -> Void {
        
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        let baseURL: String = "https://www.youtube.com/embed/"

        guard let url: URL = URL(string: "\(baseURL)\(model.youTubeView.id.videoId ?? "")") else { return }
        
        webView.load(URLRequest(url: url))
    }
}
