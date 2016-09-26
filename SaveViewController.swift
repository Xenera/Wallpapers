

import UIKit

class SaveViewController: UIViewController {

    
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(SaveViewController.updateTimer), userInfo: nil, repeats: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimer(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
