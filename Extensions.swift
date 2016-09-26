

import UIKit

let imageCache = NSCache()

var images = [UIImage]()

extension UIImageView {
    
    func loadImagesUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) in
            if error != nil {
                print(error)
                return
            }


            dispatch_async(dispatch_get_main_queue(), {
                //                    cell.imageView?.image = UIImage(data: data!)
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    self.image?.resizingMode
                    self.image = downloadedImage
                    
                    images.append(downloadedImage)
                }
            })
        }).resume()
    }
}
