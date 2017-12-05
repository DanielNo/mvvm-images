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
        guard let imageURLString = giphySearchResult.images["fixed_height_small"]?["url"] else{
            return
        }
        print(imageURLString)
        guard let imageURL = URL(string: imageURLString) else{
            return
        }
        self.imageView.kf.setImage(with: imageURL)
        ImageCache.default.calculateDiskCacheSize { size in
            print("Used disk size by bytes: \(size/1000000) mb")
        }
    }
    

}
