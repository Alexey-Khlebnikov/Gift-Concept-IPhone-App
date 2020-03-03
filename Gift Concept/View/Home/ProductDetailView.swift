//
//  ProductDetailView.swift
//  gift_app
//
//  Created by Lexy on 10/3/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class ProductDetailView: MyBaseView, iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return data?.imageIds.count ?? 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UILabel()
        view.text = String(index)
        return view
    }
    
    var data: Product? {
        didSet {
            print(data?.imageIds.count ?? -1)
        }
    }
    
    lazy var sliderView: iCarousel = {
        let height = frame.width * 9 / 16
        let slider = iCarousel(frame: CGRect(x: 0, y: 0, width: frame.width, height: height))
        slider.dataSource = self
        slider.delegate = self
        return slider
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .red
        loadData()
    }
    
    func loadData() {
        ApiService.sharedService.get(url: "product/detail") { (response) in
            self.data = Product(response)
        }
    }
}
