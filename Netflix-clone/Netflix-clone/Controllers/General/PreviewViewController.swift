//
//  PreviewViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/11.
//

import UIKit
import WebKit
import SnapKit
import Alamofire

class PreviewViewController: UIViewController {
    
    // MARK: - Stored-Prop
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    
    // MARK: - Custom Views
    private let webView: WKWebView = {
        
        let webView: WKWebView = WKWebView()
        
        webView.contentMode = .scaleAspectFit
        
        return webView
    }()
    
    private let titleLabel: UILabel = {
        
        let label: UILabel = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Movie Title"
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
        
        let label: UILabel = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.text = "Movie Overview"
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        
        let button: UIButton = UIButton()
        
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
    
    func configurePreviewVC(model: Any, video: YouTubeDataResponse.VideoElement?) -> Void {
        
        let baseURL: String = "https://www.youtube.com/embed/"
        
        if let movie: TMDBMoviesResponse.TMDBMovie = model as? TMDBMoviesResponse.TMDBMovie {
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
        } else if let tv: TMDBTVsResponse.TMDBTV = model as? TMDBTVsResponse.TMDBTV {
            self.titleLabel.text = tv.name
            self.overviewLabel.text = tv.overview
        } else if let movieItem: TMDBMovieItem = model as? TMDBMovieItem {
            self.titleLabel.text = movieItem.title
            self.overviewLabel.text = movieItem.overview
        }
        
        if let videoElement: YouTubeDataResponse.VideoElement = video {
            guard let url: URL = URL(string: "\(baseURL)\(videoElement.id.videoId ?? "")") else { return }
            
            AF.request(url)
                .validate(statusCode: 200 ..< 300)
                .response { response in
                    if let _: Data = response.data {
                        let videoHTML: String = """
                            <html>
                                <body style="margin: 0;">
                                    <iframe width="100%" height="100%" src="\(url)" frameborder="0" allowfullscreen></iframe>
                                </body>
                            </html>
                            """
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.webView.loadHTMLString(videoHTML, baseURL: url)
                        }
                    }
                }
            
            // MARK: - URLRequest
            //  webView.load(URLRequest(url: url))
        }
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
