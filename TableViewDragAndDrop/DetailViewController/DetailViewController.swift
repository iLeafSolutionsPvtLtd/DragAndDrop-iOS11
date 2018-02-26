//
//  DetailViewController.swift
//  TableViewDragAndDrop
//
//  Created by Hiran on 2/26/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?{
        didSet {
            imageView?.layer.borderColor = UIColor.green.cgColor
            imageView?.layer.borderWidth = 0.0
        }
    }
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var txtDescription: UITextView?

    var place = Place()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Enable dragging from the image view (see ViewController+Drag.swift).
        let dragInteraction = UIDragInteraction(delegate: self as UIDragInteractionDelegate)
        imageView?.addInteraction(dragInteraction)
        
        // Enable dropping onto the image view (see ViewController+Drop.swift).
        let dropInteraction = UIDropInteraction(delegate: self as UIDropInteractionDelegate)
        view.addInteraction(dropInteraction)
        
        
        self.imageView?.image = UIImage.init(named: place.image!)
        self.lblTitle?.text = place.title
        self.txtDescription?.text = place.placeDescription
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
