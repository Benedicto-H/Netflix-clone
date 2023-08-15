//
//  PreviewViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/11.
//

import UIKit
import WebKit
import SnapKit

class PreviewViewController: UIViewController {

    // MARK: - Custom Views
    private let webView: WKWebView = {
       
        let webView: WKWebView = WKWebView()
        
        //  webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private let titleLabel: UILabel = {
       
        let label: UILabel = UILabel()
        
        //  label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Movie Title"
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
       
        let label: UILabel = UILabel()
        
        //  label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.text = "Movie Overview"
        
        return label
    }()
    
    private let downloadButton: UIButton = {
       
        let button: UIButton = UIButton()
        
        //  button.translatesAutoresizingMaskIntoConstraints = false
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
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(view.frame.size.height / 3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(overviewLabel.snp.bottom).offset(25)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    func configure(with model: PreviewViewModel) -> Void {
        
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        let baseURL: String = "https://www.youtube.com/embed/"

        guard let url: URL = URL(string: "\(baseURL)\(model.youTubeView.id.videoId ?? "")") else { return }
        
        webView.load(URLRequest(url: url))
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct PreviewViewControllerRepresentable: UIViewControllerRepresentable {

    // MARK: - UIViewControllerRepresentable - (Required) Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {

        PreviewViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct PreviewViewControllerRepresentable_PreviewProvider: PreviewProvider {

    static var previews: some View {

        Group {
            PreviewViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
