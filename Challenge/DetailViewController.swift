//
//  DetailViewController.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/28/26.
//

import UIKit

/// Controller responsible for displaying a high-resolution flag and providing sharing/zooming features.
class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The filename of the image to display, passed from the main list.
    var selectedImage: String?
    
    /// The full name of the country, used for the navigation title and sharing.
    var countryName: String?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup ScrollView delegate for pinch-to-zoom functionality
        scrollView.delegate = self
        
        title = countryName
        
        // Disable Large Titles to maximize space for the image content
        navigationItem.largeTitleDisplayMode = .never
        
        // Add a standard iOS 'Share' button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        
        // Safely unwrap and load the flag image
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Immersive experience: hide bars when the user taps on the image
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Restore standard navigation behavior when leaving the screen
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Sharing Logic
    
    /// Triggers the system share sheet (UIActivityViewController)
    @objc func shareTapped() {
        // Prepare image data for sharing (0.8 quality for balance between size and detail)
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found to share")
            return
        }
        
        let items: [Any] = [image, countryName ?? "Flag"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Required for iPad: Anchor the popover to the bar button to avoid crashes
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // Exclude less relevant services to clean up the share sheet
        ac.excludedActivityTypes = [ .print, .addToReadingList, .mail ]
        
        present(ac, animated: true)
        
        // Optional completion handler for analytics or logging
        ac.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if let type = activityType {
                print("User shared via: \(type.rawValue)")
            }
        }
    }
}

// MARK: - UIScrollViewDelegate (Pinch-to-Zoom)

extension DetailViewController: UIScrollViewDelegate {
    
    /// Tells the scroll view which subview to scale during zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// Keeps the image centered in the scroll view as it scales
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    /// Optional: Resets the zoom scale when the user finishes zooming (UX decision)
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1.0, animated: true)
    }
}
