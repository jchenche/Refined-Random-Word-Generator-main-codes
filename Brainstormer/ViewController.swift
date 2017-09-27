//
//  ViewController.swift
//  Brainstormer
//
//  Created by Jimmy Chen on 2016-09-11.
//  Copyright © 2016 One-Night App. All rights reserved.
//

import UIKit
import GoogleMobil  

class ViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var filterType: UIButton!
    @IBOutlet weak var word1: UILabel!
    @IBOutlet weak var word2: UILabel!
    @IBOutlet weak var word3: UILabel!
    @IBOutlet weak var word4: UILabel!
    @IBOutlet weak var word5: UILabel!
    
    var labelArray = [UILabel]()
    
    @IBOutlet weak var backGround: UIImageView!
    
    var dataPassing:settingsView = settingsView()
    var category:String = "General"
    var wordsArray:[String] = []
    
    
    func wordFetcher() -> String {
        
        let randomAgent = Int(arc4random_uniform(UInt32(wordsArray.count)))
        return wordsArray[randomAgent]
        
    }
    
    
    @IBAction func GenerateWords(_ sender: UIButton) {
        
        for i in 0 ... (labelArray.count - 1) {
            
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 0.5
            pulseAnimation.fromValue = 0
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = false
            pulseAnimation.repeatCount = 1
            labelArray[i].layer.add(pulseAnimation, forKey: "animateOpacity")
            labelArray[i].text = wordFetcher()
            
        }
        
    }
    
    @IBAction func changeView(_ sender: AnyObject) {
        
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dataPassing.modalTransitionStyle = modalStyle
        self.present(dataPassing, animated: true, completion: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        filterType.setTitle(category, for: UIControlState())

        let path = Bundle.main.path(forResource: category, ofType: "txt")
        var text:String = ""
        
        do {
            text = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) as String
            wordsArray = text.components(separatedBy: "\n")   // Get each word separated by a line
        } catch {
            print("File is missing")
        }
        
        
        
        self.backGround.contentMode = UIViewContentMode.scaleAspectFill
        let storedRandomImageNumber = String((arc4random_uniform(5) + 1))
        backGround.image = UIImage(named: category + storedRandomImageNumber + ".jpg")
        
        let storedBackGroundName = category + storedRandomImageNumber + ".jpg"
        
        
        if storedBackGroundName == (category + "5.jpg") || storedBackGroundName == ("Art" + storedRandomImageNumber + ".jpg") || storedBackGroundName == ("Names" + storedRandomImageNumber + ".jpg") || storedBackGroundName == ("Psychology2.jpg") || storedBackGroundName == ("Science2.jpg") {
            for i in 0 ... (labelArray.count - 1) {
                labelArray[i].textColor = UIColor.white
            }
        } else {
            for i in 0 ... (labelArray.count - 1) {
                labelArray[i].textColor = UIColor.black
            }
        }
        
        
    }
    
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }
    
    
    override func viewDidLoad() {
        
        labelArray.append(word1)
        labelArray.append(word2)
        labelArray.append(word3)
        labelArray.append(word4)
        labelArray.append(word5)
        
        let request = GADRequest()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-4085124301195362/1540173936"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        dataPassing = self.storyboard!.instantiateViewController(withIdentifier: "Settings") as! settingsView
        dataPassing.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


class settingsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backGround: UIImageView!
    var delegate:ViewController? = nil
    var categoriesArray:[String] = ["General", "Names", "Places", "Science", "Mathematics", "Art", "Philosophy", "Psychology", "Health"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = categoriesArray[(indexPath as NSIndexPath).row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.category = categoriesArray[(indexPath as NSIndexPath).row]
        self.delegate?.word1.text = ""
        self.delegate?.word2.text = ""
        self.delegate?.word3.text = ""
        self.delegate?.word4.text = ""
        self.delegate?.word5.text = ""
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func animateTable() {
        
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 1
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.3, delay: 0.03 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            index += 1
        }
        
    }
    
    
    @IBAction func goToMainView(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.backGround.contentMode = UIViewContentMode.scaleAspectFill
        backGround.image = UIImage(named: "SettingViewImage.jpg")
        animateTable()
        
    }
    
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }
    
    
}
