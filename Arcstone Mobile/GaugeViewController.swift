//
//  GaugeViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 11/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SWXMLHash

class GaugeViewController: UIViewController {
    
    var gauge = SGaugeRadial(frame: CGRect(x: 0, y: 0, width: 350, height: 350), fromMinimum: 0, toMaximum: 100)
    var linearGauge = SGaugeLinear(frame: CGRect(x: 0, y: 0, width: 350, height: 40), fromMinimum: 0, toMaximum: 100)
    let label = UILabel(frame: CGRect(x: 0, y: 100, width: 300, height: 60))
    let digitalLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 300, height: 300))
    let slider = UISlider(frame: CGRect(x: 0, y: 100, width: 300, height: 20))
    var timer = Timer()
    var gaugeTimer = Timer()
    var count = 0
    var oldValue:Float = 0
    var difference:Float = 0
    var randomValue:Float = 0
    var dashboard: DashboardElement!
    var currentValue: Int = 0
    @IBOutlet weak var valueField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupGauge()
        checkGaugeType()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("In")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.startTimer()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Left")
        self.timer.invalidate()
        self.gaugeTimer.invalidate()
    }
    
    func setup() {
        print("Starting setup")
        self.oldValue = Float(self.currentValue)
        if dashboard.xml["root"]["current_value_id"].element?.text! != nil {
            DataController.getData(api_string: DataController.Routes.getCurrentValue + (dashboard.xml["root"]["current_value_id"].element?.text)!) { response in
                self.currentValue = response["value"].intValue
                self.refreshValues()
            }}
        else {
            currentValue = 0
        }
    }
    
    func refreshValues() {
        changeGaugeValue()
        label.text = String(currentValue)
        digitalLabel.text = String(currentValue)
    }
    
    func startTimer() {
        timer.invalidate()
        gaugeTimer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(setup), userInfo: nil, repeats: true)
    }
    
    func checkGaugeType() {
        switch Int(dashboard.type) {
        case DataController.dashboardType.Charts.rawValue?:
            return
        case DataController.dashboardType.Picture.rawValue?:
            return
        case DataController.dashboardType.Gauges.rawValue?:
            switch Int(dashboard.xml["root"]["type"].element!.text!) {
            case DataController.GaugeType.Digital.rawValue?:
                digitalLabel.center = view.center
                digitalLabel.center.y = view.center.y
                digitalLabel.textAlignment = NSTextAlignment.center
                digitalLabel.text = "5"
                digitalLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 170)
                self.view.addSubview(digitalLabel)
            case DataController.GaugeType.FullCircle.rawValue?:
                gauge?.style.borderIsFullCircle = true
                gauge?.arcAngleStart = CGFloat(-Double.pi/4 * 3)
                gauge?.arcAngleEnd = CGFloat(Double.pi/4 * 3)
                gauge?.maximumValue = Int(dashboard.xml["root"]["end_value"].element!.text!)! as NSNumber
                gauge?.minimumValue = Int(dashboard.xml["root"]["start_value"].element!.text!)! as NSNumber
                view.addSubview(gauge!)
            case DataController.GaugeType.HalfCircle.rawValue?:
                gauge?.style.borderIsFullCircle = false
                gauge?.arcAngleStart = CGFloat(-Double.pi/4 * 2)
                gauge?.arcAngleEnd = CGFloat(Double.pi/4 * 2)
                gauge?.maximumValue = Int(dashboard.xml["root"]["end_value"].element!.text!)! as NSNumber
                gauge?.minimumValue = Int(dashboard.xml["root"]["start_value"].element!.text!)! as NSNumber
                view.addSubview(gauge!)
            case DataController.GaugeType.HorizontalBar.rawValue?:
                linearGauge?.maximumValue = Int(dashboard.xml["root"]["end_value"].element!.text!)! as NSNumber
                linearGauge?.minimumValue = Int(dashboard.xml["root"]["start_value"].element!.text!)! as NSNumber
                view.addSubview(linearGauge!)
            case DataController.GaugeType.QuarterLeftCircle.rawValue?:
                return
            case DataController.GaugeType.QuarterRightCircle.rawValue?:
                return
            case DataController.GaugeType.StateIndicator.rawValue?:
                return
            case DataController.GaugeType.VerticalBar.rawValue?:
                linearGauge = SGaugeLinear(frame: CGRect(x: (self.view.frame.width-60)/2, y: (self.view.frame.height-350)/2, width: 60, height: 350), fromMinimum: 0, toMaximum: 100)
                linearGauge?.style = SGaugeDashboardStyle()
                linearGauge?.orientation = .vertical
                linearGauge?.maximumValue = Int(dashboard.xml["root"]["end_value"].element!.text!)! as NSNumber
                linearGauge?.minimumValue = Int(dashboard.xml["root"]["start_value"].element!.text!)! as NSNumber
                view.addSubview(linearGauge!)
            default:
                return
            }
            
        case DataController.dashboardType.Text.rawValue?:
            label.center = view.center
            label.center.y = view.center.y
            label.textAlignment = NSTextAlignment.center
            label.text = dashboard.name
            self.view.addSubview(label)
        default:
            print("Not found")
        }
    }
    
    func setupGauge() {
        gauge?.center = view.center
        linearGauge?.center = view.center
        linearGauge?.style = SGaugeDashboardStyle()
        gauge?.style = SGaugeDashboardStyle()
        gauge?.style.bevelWidth = 12
        gauge?.style.bevelFlatProportion = 0.75
        gauge?.center.y = view.center.y
    }
    
    func changeGaugeValue() {
        count = 0
        difference = Float(currentValue) - oldValue
        if difference != 0 {
            gaugeTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(changeValue), userInfo: nil, repeats: true)
        }
    }
    
    func changeValue() {
        count += 1
        if count > 100 {
            gaugeTimer.invalidate()
            oldValue = Float((gauge?.value)!)
        }
        else {
            gauge?.value += CGFloat(difference/100)
            linearGauge?.value += CGFloat(difference/100)
        }
    }
    
    
    //    @IBAction func submitAction(_ sender: Any) {
    //
    //        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getRandomValue), userInfo: nil, repeats: true)
    //
    //    }
    
    //
    //    func sliderValueChanged(_sender: UISlider!) {
    //        gauge?.value = CGFloat(slider.value)
    //    }
    //
    //
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
