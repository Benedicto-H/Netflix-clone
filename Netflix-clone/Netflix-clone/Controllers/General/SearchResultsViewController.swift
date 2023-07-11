//
//  SearchResultsViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/07.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    // MARK: - Stored-Props
    public var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    private var tmdbTvs: [TMDBTVsResponse.TMDBTV] = [TMDBTVsResponse.TMDBTV]()

    // MARK: - Custom View
    public let searchResultsCollectionView: UICollectionView = {
       
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 0
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegateFlowLayout - (optional) Method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (UIScreen.main.bounds.width / 3) - 10, height: 200)
    }
    
    // MARK: - UICollectionViewDataSource - (Required) Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return max(tmdbMovies.count, tmdbTvs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        //  cell.backgroundColor = .systemBackground
        
        cell.configure(with: tmdbMovies[indexPath.row].poster_path ?? "")
        
        return cell
    }
}
