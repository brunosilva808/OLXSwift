//
//  ViewController.swift
//  OLXSwift
//
//  Created by Bruno1 on 27/03/2019.
//

import UIKit

class ViewController: UITableViewController {

    var videosRequest = Request.Videos(page: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManagerNew().response(with: self.videosRequest, onSuccess: { [weak self] (response) in
            self?.videosRequest.page += 1
        }, onError: { (error) in
            
        }) {}
    }

}
