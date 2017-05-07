//
//  DashboardWebViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 6/5/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SVProgressHUD

class DashboardWebViewController: UIViewController, UIWebViewDelegate {
    
    let url = "http://" + UserDefaults.standard.string(forKey: "DashboardAddress")! + "/DxDashboard.aspx?id="
    var dashboardId: String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let url = URL(string: self.url + dashboardId)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        SVProgressHUD.dismiss()
        // Do any additional setup after loading the view.
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
