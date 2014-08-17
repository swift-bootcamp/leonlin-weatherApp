//
//  ViewController.swift
//  weatherApp
//
//  Created by Lin wei-chih on 2014/8/16.
//  Copyright (c) 2014年 Lin wei-chih. All rights reserved.
//

import UIKit

//set protocol
class ViewController: UIViewController, NSURLConnectionDelegate {
    
    //IBOutlet let storyBoard view Control can see the string
    @IBOutlet var city: UILabel!
    //x:-16 y:80
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var windSpeed: UILabel!
    
    // 使用 NSMutableData 儲存下載資料
    var data: NSMutableData = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.city.text = "Taipei"
        
        //background
        let background = UIImage(named: "CloudyDay_bg320px.png")
        self.view.backgroundColor = UIColor(patternImage: background)
        
        //touch the screen for download
        //let singleFingerTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        //self.view.addGestureRecognizer(singleFingerTap)
        
        //func handleSingleTap (recognizer: UITapGestureRecognizer) {
        //    startConnection()
        //}
        
        startConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //start download
    func startConnection() {
        var restAPI: String = "http://api.openweathermap.org/data/2.5/weather?q=Taipei"
        var url: NSURL = NSURL(string: restAPI)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
        println("start download")
    }
    
    //Downloading
    func connection(connection: NSURLConnection!, didReceiveData dataReceived: NSData!) {
        println("downloading")
        
        self.data.appendData(dataReceived)
        //self.data.setData(dataReceived)

    }
    
    //Finish Download
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        println("download finished")
        
        var json = NSString(data: data, encoding: NSUTF8StringEncoding)
        println(json)
        
        // 解析 JSON
        // 使用 NSDictionary: NSDictionary 是一種 Associative Array 的資料結構
        var error: NSError?
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        // 讀取各項天氣資訊
        let temp: AnyObject? = jsonDictionary["main"]?["temp"]
        let humidity: AnyObject? = jsonDictionary["main"]?["humidity"]
        let speed: AnyObject? = jsonDictionary["wind"]?["speed"]
        
        // use '?' to downcast to NSArray
        if let weather = jsonDictionary["weather"]? as? NSArray {
            // Safe code 寫作觀念:
            // 使用 as? 轉型時，要把以下這行放進 if statement 裡處理
            let weatherDictionary = (weather[0] as NSDictionary)
            // 天氣狀態 (多雲、晴朗等等)
            updateWeatherConditionIcon(weatherDictionary["id"] as Int)
        }
        
        //  溫度資料處理
        let weatherTempCelsius = Int(round((temp!.floatValue - 273.15)))
        let weatherTempFahrenheit = Int(round(((temp!.floatValue - 273.15) * 1.8) + 32))
        let weatherHumidity = round(humidity!.floatValue)
        let weatheWindrSpeed = round(speed!.floatValue)
        
        // 測試輸出
        println("temp: \(weatherTempCelsius)℃")
        println("humidity: \(weatherHumidity)")
        println("speed: \(weatheWindrSpeed)m/s")
        
        // 輸出到 UI
        self.temperature.font = UIFont.boldSystemFontOfSize(28)
        self.temperature.text = "\(weatherTempCelsius)℃"
        self.humidity.text = "\(weatherHumidity)"
        self.windSpeed.text = "\(weatheWindrSpeed) m/s"

    }
    
    // 解讀 Weather Condition Code
    // See: http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
    func updateWeatherConditionIcon(weatherId: Int) {
        println("weather ID: \(weatherId)")
        
        switch weatherId {
        case 500, 501, 502, 503, 504:
            self.icon.image = UIImage(named: "RAIN")
            let background = UIImage(named: "rain_bg320px.png")
            self.view.backgroundColor = UIColor(patternImage: background)
            
        case 800, 801, 802:
            self.icon.image = UIImage(named: "sun.png")
            let background = UIImage(named: "sun_bg320px.png")
            self.view.backgroundColor = UIColor(patternImage: background)
            
        case 803, 804:
            self.icon.image = UIImage(named: "CloudyDay.png")
            let background = UIImage(named: "CloudyDay_bg320px.png")
            self.view.backgroundColor = UIColor(patternImage: background)
            
        default:
            println("no weather icon")
        }
    }
}

