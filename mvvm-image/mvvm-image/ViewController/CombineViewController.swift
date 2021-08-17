/*
View controller cannot directly communicate with the Model, data is exposed through the view model
 Bind the View(User interface) to a stream of events with RxSwift

 A view(view controller and ui components) gets data from its ViewModel through BINDINGS, or invoking methods on the view model.
 Here the UI is : CollectionView, SearchBar
 and it is registering for changes in the Model through the view model
 
 */


import UIKit
import Combine
import Kingfisher


class CombineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let viewModel = GifSearchViewModel()
    let imageCellIdentifier = "imageCell"
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for gifs"
        return searchController
    }()
    
    enum Section : String{
        case main
    }
    
    lazy var dataSource : UICollectionViewDiffableDataSource<Section,GiphySearchResult> =
        {
            
            let dSource : UICollectionViewDiffableDataSource<Section,GiphySearchResult> = UICollectionViewDiffableDataSource(collectionView: collectionView!) { (cv, indexPath, item) -> UICollectionViewCell? in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseID, for: indexPath) as! ImageCollectionViewCell
                cell.configureCell(giphySearchResult: item)
                return cell

            }
        return dSource
        }()
    
    var subs : Set<AnyCancellable> = Set()
    var searchBarSubject : PassthroughSubject<String,Never> = PassthroughSubject<String,Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCombine()
    }
    
    func setupUI(){
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: imageCellIdentifier)
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
        self.navigationItem.searchController = searchController
        applySnapshot([])
    }
    
    func setupCombine(){
        viewModel.$combineSearchResults.throttle(for: 0.0, scheduler: RunLoop.main, latest: true).subscribe(on: RunLoop.main).sink { results in
//            print(results)
            self.applySnapshot(results)
        }.store(in: &subs)

        searchBarSubject.filter({ str in
            str.count > 2
        })
        .debounce(for: 0.4, scheduler: RunLoop.main)
        .throttle(for: 0.4, scheduler: RunLoop.main, latest: true)
        .sink(receiveCompletion: { output in
            print("\(output)")
        }, receiveValue: { [unowned self] val in
            self.viewModel.searchGiphyCombine(query: val)
            print("received value from stream :\(val)")
        })
        .store(in: &subs)

    }
    
    func applySnapshot(_ searchResults : [GiphySearchResult]? = []){
        let items : [GiphySearchResult] = searchResults ?? []
       
        var snapshot = NSDiffableDataSourceSnapshot<Section,GiphySearchResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CombineViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        
        searchBarSubject.send(text)
        
    }
}

extension CombineViewController{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }


}
