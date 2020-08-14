//
//  RightViewController.swift
//  SlideMenuSwift
//
//  Created by LTMAC on 2020/8/11.
//  Copyright © 2020 LTMAC. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.lt_slideMenu?.showRootViewController(animated: true)
        let secondVC = SecondViewController.init()
        self.lt_slideMenu?.naviRootViewController?.pushViewController(secondVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
