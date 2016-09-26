

import UIKit
import Firebase

class ViewController: UIViewController, MenuViewControllerDelegate, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    
    let transition = Circular()
    var blackMask = UIView(frame: CGRectZero)
    var indexPath: NSIndexPath!
    var imagesForSave = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func menuButtonDidTouch(sender: AnyObject) {
        
        
        toggleMenu()
    }
    
    @IBOutlet weak var saveBUttonStyle: UIButton!
    
   
    
    @IBAction func shareButton(sender: AnyObject) {
        shareButtonClicked()
    }
    
    @IBOutlet weak var menuButtonStyle: UIButton!
    
    @IBOutlet weak var shareButtonStyle: UIButton!
    
    
    weak var activitiIndicatorView: UIActivityIndicatorView!
    
    var visibleCell = [UICollectionViewCell]()
    
    func menuCloseButtonTapped() {
        toggleMenu()
    }
    
    var menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
    var menuLeftConstraint : NSLayoutConstraint?
    var isShownMenu = true

    
    var imageArray = [Images]()
   
    
    let shareMessage = "Wallpapers Created by Ернур Сункарбек on 20.07.16.Copyright © 2016 Ернур Сункарбек. All rights reserved."
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        let rect = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 100, height: 100)
        var activitiIndicatorView = UIActivityIndicatorView(frame: rect)
        activitiIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        collectionView.backgroundView = activitiIndicatorView
        self.activitiIndicatorView = activitiIndicatorView
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

        self.navigationController?.navigationBar.translucent = true
        
        addChildViewController(menuViewController)
        menuViewController.delegate = self
        menuViewController.didMoveToParentViewController(self)
        menuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuViewController.view)
        
        let topConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
        menuLeftConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: -widthConstraint.constant)
        view.addConstraints([topConstraint, bottomConstraint, widthConstraint, menuLeftConstraint!])
        
        saveBUttonStyle.layer.cornerRadius = saveBUttonStyle.frame.size.width / 2
        saveBUttonStyle.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        menuButtonStyle.layer.cornerRadius = menuButtonStyle.frame.size.width / 2
        menuButtonStyle.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        shareButtonStyle.layer.cornerRadius = shareButtonStyle.frame.size.width / 2
        shareButtonStyle.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        
        saveBUttonStyle.addTarget(self, action: #selector(ViewController.saveButtonClicked(_:)), forControlEvents: .TouchDown)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (imageArray.count == 0) {
            activitiIndicatorView.startAnimating()
            
        } else {
            activitiIndicatorView.stopAnimating()
            activitiIndicatorView.hidden = true
        }
        fetchImages()
    }
    
    func toggleMenu() {
        
        isShownMenu = !isShownMenu
        
        if (isShownMenu) {
            
            //hide menu
            menuLeftConstraint?.constant = -menuViewController.view.bounds.size.width
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .CurveEaseInOut,animations: {() -> Void in
                    self.view.layoutIfNeeded()
                }, completion: { (completed) -> Void in
                    self.menuViewController.view.hidden = true
            })
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {() -> Void in
                self.view.layoutIfNeeded()
                self.blackMask.alpha = 0.0
                }, completion: {(completed) -> Void in
                    self.blackMask.removeFromSuperview()
            })
            
        } else {
            
//            show menu
            blackMask = UIView(frame: CGRectZero)
            blackMask.alpha = 0.0
            blackMask.translatesAutoresizingMaskIntoConstraints = false
            blackMask.backgroundColor = UIColor.blackColor()
            view.insertSubview(blackMask, belowSubview: menuViewController.view)
            
            let topConstraint = NSLayoutConstraint(item: blackMask, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: blackMask, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: blackMask, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: blackMask, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing , multiplier: 1, constant: 0)
            
            view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
            view.layoutIfNeeded()
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.blackMask.alpha = 0.5
                
                }, completion: { (completed) -> Void in
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureRecognizer))
                    self.blackMask.addGestureRecognizer(tapGestureRecognizer)
                    
            })
            menuViewController.view.hidden = false
            menuLeftConstraint?.constant = 0
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .CurveEaseInOut,animations: {() -> Void in
                self.view.layoutIfNeeded()
                }, completion: { (completed) -> Void in
            })
        }
        
    }
    
    func tapGestureRecognizer() {
        toggleMenu()
    }
 
    
    func shareButtonClicked() {
       displayShareSheet(shareMessage)
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
    func fetchImages() {

        
        FIRDatabase.database().reference().child("ALLImages").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let image = Images()
                image.setValuesForKeysWithDictionary(dictionary)
                self.imageArray.append(image)
                

                dispatch_async(dispatch_get_main_queue(), {

                    self.collectionView.reloadData()
                })
            }
        }, withCancelBlock: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    var downImg = UIImage()
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! NewCollectionViewCell
       
        let image = imageArray[indexPath.row]
        if let imageUrl = image.imageUrl {
            
                cell.img.loadImagesUsingCacheWithUrlString(imageUrl)
                   }
       
        cell.img.widthAnchor.constraintEqualToAnchor(collectionView.widthAnchor)
        cell.img.heightAnchor.constraintEqualToAnchor(collectionView.heightAnchor)
        
        return cell
        
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.indexPath = indexPath
    }
    
    func saveButtonClicked(button: UIButton) {
        print("Save Button clicked")
        let img = imageArray[indexPath.row]
        let imageView :UIImageView = UIImageView(image: UIImage(named: "nature.png"))
        if let downloadUrl = img.imageUrl{
            imageView.loadImagesUsingCacheWithUrlString(downloadUrl)
            UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        } else {
            print("errr")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSizeMake(self.collectionView!.frame.size.width, self.collectionView!.frame.size.height + 64)
        return size
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let secondVC = segue.destinationViewController as! SaveViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .Custom
    }
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.starttingPoint = saveBUttonStyle.center
    transition.circleColor = saveBUttonStyle.backgroundColor!
    
    return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.starttingPoint = saveBUttonStyle.center
        transition.circleColor = saveBUttonStyle.backgroundColor!
        
        return transition
    }

   
    
    
}



