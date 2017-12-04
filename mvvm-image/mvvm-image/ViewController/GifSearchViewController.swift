//
//  GifSearchViewController.swift
//  mvvm-image
//
//  Created by Daniel No on 10/29/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import FLAnimatedImage

class GifSearchViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let viewModel = GifSearchViewModel()
    let disposeBag = DisposeBag()
    let imageCellIdentifier = "imageCell"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: imageCellIdentifier)
            let flowLayout = UICollectionViewFlowLayout()
            collectionView.setCollectionViewLayout(flowLayout, animated: true)
            collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GifSearchViewController{
    
    func setupBindings(){
        setupUIBindings()
        setupCollectionViewBindings()
        
    }
    
    func setupUIBindings(){
        searchBar.rx.text
            .orEmpty
            .asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self](str) in
                print("typed : \(str)")
                self.viewModel.searchGiphy(query: str)
                self.collectionView.reloadData()
                }, onError: { (err) in
                    print(err)
            }, onCompleted: {
                print("completed")
            }).disposed(by: disposeBag)

    }
}

extension GifSearchViewController{

    func setupCollectionViewBindings(){
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ImageCollectionViewSection>(configureCell:{datasource, collectionView, index, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.imageCellIdentifier, for: index) as! ImageCollectionViewCell
            let searchResult = self.viewModel.giphySearchResults.value[index.row]
            cell.configureCell(giphySearchResult: searchResult)
            
            return cell
        }, configureSupplementaryView: {dataSource,collectionView,str,index in
            return UICollectionReusableView()
        })
        
        viewModel.giphySearchResults.asDriver()
            .map {
                [ImageCollectionViewSection(header: self.searchBar.text!, items: $0)]
            }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 2 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }


}
