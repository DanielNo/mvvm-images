//
//  ImageCollectionViewSection.swift
//  mvvm-image
//
//  Created by Daniel No on 11/24/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources


struct ImageCollectionViewSection {
    var header: String
    var items: [Item]
}

extension ImageCollectionViewSection: AnimatableSectionModelType {
    
    typealias Item = GiphySearchResult
    
    var identity: String {
        return header
    }
    
    init(original: ImageCollectionViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
