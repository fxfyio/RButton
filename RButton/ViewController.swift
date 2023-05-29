//
//  ViewController.swift
//  RButton
//
//  Created by Eric on 5/16/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rbutton = RButton(frame: CGRect(x: (self.view.frame.width - 300) / 2.0 , y: 200, width: 300, height: 150))
        rbutton.setTitle("button", for: .normal)
        rbutton.colors = [UIColor.red, UIColor.blue]
        rbutton.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .medium)
        self.view.addSubview(rbutton)
        self.view.backgroundColor = .black
        
        
        
        let rbutton1 = RButton(frame: CGRect(x:  (self.view.frame.width - 300) / 2.0 , y: 400, width: 300, height: 150))
        rbutton1.setTitle("button", for: .normal)
        rbutton1.colors = [UIColor.red, UIColor.blue]
        rbutton1.style = .border(width: 5)
        rbutton1.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .medium)
        self.view.addSubview(rbutton1)
        self.view.backgroundColor = .black
    }


}

