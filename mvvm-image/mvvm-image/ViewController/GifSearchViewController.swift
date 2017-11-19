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

class GifSearchViewController: UIViewController {
    
    let viewModel = GifSearchViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GifSearchViewController{
    
    func setupBindings(){
        searchBar.rx.text
            .orEmpty
            .asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { (str) in
                print(str)
                self.viewModel.searchGiphy(query: str)
            }, onError: { (err) in
                print(err)
            }, onCompleted: {
                print("completed")
            }).disposed(by: disposeBag)

    }
    
    
}
