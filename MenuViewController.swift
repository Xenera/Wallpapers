

import UIKit
protocol MenuViewControllerDelegate {
    func menuCloseButtonTapped()
}

class MenuViewController: UITableViewController {

    var delegate : MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
//        self.view.tintColor = .greenColor()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cellIdentifier = "cell"
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
//        
//        cell.backgroundColor = UIColor.clearColor()
//        cell.backgroundView =
//            [[UIView new] autorelease
//        cell.selectedBackgroundView = [[UIView new] autorelease];
////
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
//        
//        switch indexPath.row {
//        case 0:
//            cell.textLabel?.text = "Abstract"
//        case 1:
//            cell.textLabel?.text = "Cars"
//        case 2:
//            cell.textLabel?.text = "Nature"
//        default:
//            print("error")
//        }
//        
//     return cell
//    }
    
    
    
    @IBAction func menuCloseTouched(sender: AnyObject) {
        delegate?.menuCloseButtonTapped()
        
    }
    
    
    
}
