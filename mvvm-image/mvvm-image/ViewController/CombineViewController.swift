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


class CombineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let viewModel = GifSearchViewModel()
    let disposeBag = DisposeBag()
    let imageCellIdentifier = "imageCell"
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: imageCellIdentifier)
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CombineViewController{
    
    
    // Invoke a method on the view model and binds to the data provided
    
}

extension CombineViewController{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let searchResult = self.viewModel.giphySearchResults.value[indexPath.row]
        
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 2 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }


}
