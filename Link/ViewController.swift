//
//  ViewController.swift
//  Link
//
//  Created by sculpsoft-mac on 04/01/19.
//  Copyright © 2019 IND. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var theLabel: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let stringgg = "www.google5.com Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,www.google.com when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum www.google1.com"
        
        
        
        
        theLabel.setTextWithLinks(textWithString: stringgg) { (linkClicked) in
            print(linkClicked)
        }
        
        
    }

}





