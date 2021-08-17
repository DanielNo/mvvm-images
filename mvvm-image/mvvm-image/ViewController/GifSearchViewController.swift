/*
View controller cannot directly communicate with the Model, data is exposed through the view model
 Bind the View(User interface) to a stream of events with RxSwift

 A view(view controller and ui components) gets data from its ViewModel through BINDINGS, or invoking methods on the view model.
 Here the UI is : CollectionView, SearchBar
 and it is registering for changes in the Model through the view model
 
 */


import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Kingfisher


class GifSearchViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let viewModel = GifSearchViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseID)
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
    
    // Invoke a method on the view model and binds to the data provided
    func setupUIBindings(){
        searchBar.rx.text
            .orEmpty
            .asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ return $0.count >= 2
            })
            .subscribe(onNext: { [unowned self](str) in
                print("typed : \(str)")
                self.viewModel.searchGiphyRxSwift(query: str)
                self.collectionView.reloadData()
                }, onError: { (err) in
                    print(err)
            }, onCompleted: {
                print("completed")
            }).disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .asObservable()
            .filter {
                return $0.count == 0
            }.subscribe(onNext: { _ in
                print("empty search text")
                }).disposed(by: disposeBag)
        
    }
    
}

extension GifSearchViewController{

    func setupCollectionViewBindings(){
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ImageCollectionViewSection>(configureCell:{datasource, collectionView, index, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseID, for: index) as! ImageCollectionViewCell
            cell.configureCell(giphySearchResult: item)
            
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
        let searchResult = self.viewModel.giphySearchResults.value[indexPath.row]
        
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 2 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }


}
