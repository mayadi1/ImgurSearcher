//
//  detailViewController.swift
//  ImgurSearcher
//
//  Created by Mohamed Ayadi on 1/14/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    var image = UIImage()
    @IBOutlet weak var imageView: CustomImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = self.image
    }

}
