//
//  ViewController.swift
//  OLXSwift
//
//  Created by Bruno1 on 27/03/2019.
//

import UIKit
import youtube_ios_player_helper_swift

class ViewController: UITableViewController {

    private var videosRequest = Request.Videos(page: 1)
    private var array: [Response.Resource] = []
    private var rowSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.setupTableView()
        self.setupSpinner()
        self.getResources()
    }
    
    func getResources() {
        
        self.tableView.tableFooterView?.isHidden = false
        
        NetworkManagerNew().response(with: self.videosRequest, onSuccess: { [unowned self] (response) in
            
            guard response.resource.count != 0 else { return }
            
            self.videosRequest.page += 1
            self.array.append(contentsOf: response.resource)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, onError: { (error) in }) {
                
            DispatchQueue.main.async { [unowned self] in
                self.tableView.tableFooterView?.isHidden = true
            }
        }
    }
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 230
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.registerNib(for: VideoCell.self)
    }
    
    func setupSpinner() {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = true
    }

}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(for: indexPath, with: array[indexPath.row]) as VideoCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == array.count - 2 {
            self.getResources()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        detailViewController.resource = self.array[indexPath.row]
//        detailViewController.delegate = self
        
        pageViewController.array = self.array
        pageViewController.rowSelected = indexPath.row
        self.rowSelected = indexPath.row
        self.navigationController?.pushViewController(pageViewController, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailViewController = DetailViewController()
//        detailViewController.resource = self.array[indexPath.row]
//        detailViewController.delegate = self
//
//        self.rowSelected = indexPath.row
//        self.navigationController?.pushViewController(detailViewController, animated: true)
//    }
    
}

extension ViewController: PlayerDelegate {

    func playerStateChanged(state: YTPlayerState) {
        self.tableView.reloadRows(at: [IndexPath(item: self.rowSelected, section: 0)], with: .none)
    }
}
