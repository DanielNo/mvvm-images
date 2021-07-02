//
//  ImageCollectionViewCell.swift
//  mvvm-image
//
//  Created by Daniel No on 11/20/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(giphySearchResult : GiphySearchResult){
        guard let imageURLString = giphySearchResult.images["fixed_width_small"]?["url"] else{
            return
        }
        print(imageURLString)
        guard let imageURL = URL(string: imageURLString) else{
            return
        }
        let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURLString)
        
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: resource)
    }
    

}
