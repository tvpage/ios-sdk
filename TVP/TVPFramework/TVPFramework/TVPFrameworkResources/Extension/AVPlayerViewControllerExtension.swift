

import UIKit
import MediaPlayer
import AVKit

extension AVPlayerViewController {
    // override 'viewWillDisappear'
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // and then , post a simple notification and observe & handle it, where & when you need to.....
        NotificationCenter.default.post(name: .kAVPlayerViewControllerDismissingNotification, object: nil)
        
        // now, check that this ViewController is dismissing
        if self.isBeingDismissed == false {
            return
        }
    }
}
