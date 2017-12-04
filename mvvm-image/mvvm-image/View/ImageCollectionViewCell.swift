//
//  ImageCollectionViewCell.swift
//  mvvm-image
//
//  Created by Daniel No on 11/20/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import UIKit
import FLAnimatedImage
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(giphySearchResult : GiphySearchResult){
        
        guard let imageURLString = giphySearchResult.images["fixed_height"]?["url"] else{
            return
        }
        print(imageURLString)
        guard let imageURL = URL(string: imageURLString) else{
            return
        }
        
        do {
            let data = try Data(contentsOf: imageURL)
            let flImage = FLAnimatedImage(gifData: data)
            self.imageView.animatedImage = flImage
        } catch {
            print(error.localizedDescription)
        }

    }
    

}
