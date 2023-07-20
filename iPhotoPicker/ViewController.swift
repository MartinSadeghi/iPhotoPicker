//
//  ViewController.swift
//  iPhotoPicker
//
//  Created by Mommo Sadeghi on 19/07/23.
//

import UIKit
import PhotosUI


class ViewController: UIViewController {
    
    
        // MARK:  - Variables
    
    var selectedPhotos = [UIImage]()
    
    
        // MARK:  - Outlets
    @IBOutlet weak var addPhotoButtonTapped: UIBarButtonItem!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    
        // MARK:  - Application Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addPhotoButtonTapped(_ sender: UIBarButtonItem) {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = self
        self.present(photoPickerViewController, animated: true)
    }

}

    // MARK:  - Extension of PHPickerViewControllerDelegate

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for photoResult in results {
            photoResult.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.selectedPhotos.append(image)
                }
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
                }
            }
        }
    }
}



// MARK:  - Extension of UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
        cell.cellImageView.image = selectedPhotos[indexPath.row]
        return cell
    }
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

