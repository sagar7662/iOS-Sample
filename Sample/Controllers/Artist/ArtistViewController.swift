//
//  ArtistViewController.swift
//  Sample
//
//  Created by SK on 7/12/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher

class ArtistViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: ArtistCollectionViewCell.self)
        }
    }
    
    private var artists = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Artists"
        getArtists()
    }
    
    private func getArtists() {
        LoaderView.showIndicator(view)
        let parameter = ["method": "chart.gettopartists", "api_key": "ca90dae411d322f87b3877847216b83e", "format": "json", "limit": "20"]
        SampleServiceManager.getTopArtists(parameters: parameter, success: { [weak self] (response) in
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
        if let responseDict = response as? [String: Any], let artists = responseDict["artists"] as? [String: Any], let artist = artists["artist"] as? [[String: Any]] {
            for artistDict in artist {
                if let artist = Mapper<Artist>().map(JSON: artistDict) {
                    self.artists.append(artist)
                }
            }
            collectionView.reloadData()
        } else {
            LoaderView.showMessage("No Data Found", onView: view, isSearch: false, completion: {})
        }
    }
}

extension ArtistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ArtistCollectionViewCell.self)
        
        let artist = artists[indexPath.item]
        
        cell.artistNameLabel.text = artist.name
        cell.artistImageView.image = nil
        if let image = artist.images.last, let url = URL(string: image.text) {
            cell.artistImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
}

extension ArtistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = AlbumViewController.instantiate(fromAppStoryboard: .Main)
        controller.selectedArtist = artists[indexPath.item]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
    }
}

