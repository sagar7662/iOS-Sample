//
//  AlbumViewController.swift
//  Sample
//
//  Created by SK on 7/12/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher

class AlbumViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: AlbumTableViewCell.self)
        }
    }
    
    var selectedArtist: Artist?
    private var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Albums"
        getAlbums()
    }
    
    private func getAlbums() {
        LoaderView.showIndicator(view)
        let parameter = ["method": "artist.gettopalbums", "mbid": selectedArtist?.mbid ?? "", "format": "json", "api_key": "ca90dae411d322f87b3877847216b83e", "limit": "20"]
        SampleServiceManager.getTopAlbums(parameters: parameter, success: { [weak self] (response) in
            guard let `self` = self else { return }
            self.handleSuccessResponse(response)
        }) { [weak self] (error) in
            guard let `self` = self else { return }
            LoaderView.remove(self.view)
            self.alert(message: error.localizedDescription)
        }
    }
    
    private func handleSuccessResponse(_ response: Any) {
        LoaderView.remove(view)
        if let responseDict = response as? [String: Any], let topAlbums = responseDict["topalbums"] as? [String: Any], let album = topAlbums["album"] as? [[String: Any]] {
            for albumDict in album {
                if let album = Mapper<Album>().map(JSON: albumDict) {
                    self.albums.append(album)
                }
            }
            tableView.reloadData()
        } else {
            LoaderView.showMessage("No Data Found", onView: view, isSearch: false, completion: {})
        }
    }
}

extension AlbumViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: AlbumTableViewCell.self)
        
        let album = albums[indexPath.row]

        cell.albumNameLabel.text = album.name
        cell.albumImageView.image = nil
        if let image = album.images.last, let url = URL(string: image.text) {
            cell.albumImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
}
