//
//  DetailViewController.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/28/26.
//

import UIKit

class DetailViewController: UIViewController {
    
    // Properties to receive data from the main list
    var selectedImage: String?
    var countryName: String?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Use country name as the screen title
        title = countryName
        
        // Disable Large Titles for this specific screen to save space
        navigationItem.largeTitleDisplayMode = .never
        
        // Add a standard 'Action' button (share icon) to the top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // Load the image into the view if the filename exists
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    // Show/Hide navigation bar on tap for a full-screen image effect
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Sharing Logic
    @objc func shareTapped() {
        // Safely get the image data and the text we want to share
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found to share")
            return
        }
        
        let items: [Any] = [image, countryName ?? "Flag"]
        
        // Initialize the standard iOS share sheet
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Required for iPad support: tells the OS where the popover should point to
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
        // Exclude specific services if we don't want them in the list
        ac.excludedActivityTypes = [ .print, .addToReadingList, .mail ]
        
        // Track the user's action (did they share it or cancel?)
        ac.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if let type = activityType {
                print("User used service: \(type.rawValue)")
            }
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1.0, animated: true)
    }
    
}
