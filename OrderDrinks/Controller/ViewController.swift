//
//  ViewController.swift
//  OrderDrinks
//
//  Created by 顏禹文 on 2019/07/29.
//  Copyright © 2019 顏禹文. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var myview: UIView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var selectDrink: UIPickerView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var sizeSegmented: UISegmentedControl!
    @IBOutlet weak var sugerSegmented: UISegmentedControl!
    @IBOutlet weak var iceSegmented: UISegmentedControl!
    @IBOutlet weak var addSwitch: UISwitch!
    @IBOutlet weak var orderBtn: UIButton!
    
    // MARK: - Class properties
    var drinkName: String?
    var order: Order?
    var refreshView = UIActivityIndicatorView()
    var drinkIndex = 0
    var pickerData: [String] = [String]()
    var MoneyArray = [String]()
    var drinkItem = ""
    var Money = ""
    
    // MARK: - View controller function
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        txtName.placeholder = "名前を入力してください"
        txtName.inputAccessoryView = toolbar
        
        selectDrink.delegate = self
        selectDrink.dataSource = self
        txtName.delegate = self
        
        //點螢幕任何地方讓鍵盤自動收起
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        teaList()
        drinkItem = pickerData[0]
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func teaList(){
        
        let url = Bundle.main.path(forResource: "TeaList", ofType: "txt")
        let content = try! String(contentsOfFile: url!, encoding: String.Encoding.utf8)
        var listArray = content.components(separatedBy: "\n")
        if(listArray.count > 0) {
            for i in 0...listArray.count - 1 {
                if i % 2 == 0 {
                    pickerData.append(listArray[i])
                } else {
                    MoneyArray.append(listArray[i])
                }
            }
        }
    }
    
    // MARK: -Picker view Layout 飲料選單的出現
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(myview)
        myview.translatesAutoresizingMaskIntoConstraints = false
        
        myview.heightAnchor.constraint(equalToConstant: 200).isActive = true
        myview.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0).isActive = true    //view元件的左邊的x的軸座標，加10要等於myView的左邊的x座標
        myview.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0).isActive = true  //右邊
        let c = myview.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 200) //下面
        c.identifier = "bottom" //下面
        c.isActive = true       //下面
        
        //圓角
        myview.layer.cornerRadius = 27
        
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Picker view data source
                    // 有幾個構成元素
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
                    // 滾輪上有幾筆資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
                    // 每筆資料要顯示什麼字串
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    // MARK: -Picker view button Activite
                    //飲料清單選擇完成 （按鈕的動作）
    @IBAction func doneClick(_ sender: Any) {
        let title =  pickerData[selectDrink.selectedRow(inComponent: 0)]
        selectBtn.setTitle(title, for: .normal)
        displayPickerView(false)
    }
                    //請選擇飲料
    @IBAction func selectClick(_ sender: Any) {
        displayPickerView(true)
    }
                    //設定布林值函數，上方兩個可以回傳
    func displayPickerView(_ show: Bool) {
        for c in view.constraints {
            if c.identifier == "bottom" {
                c.constant = (show) ? -85 : 200  //true的話顯示上下座標位置-85,false的話顯示200
                break
            }
        }
        UIView.animate(withDuration: 0.3) {   //出現的速度
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - IBActions
                    //return button 鍵盤的出現
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.1) {
            self.txtName.resignFirstResponder() //收回keyboard
        }
        return true
    }
    
     //Done button
    @IBAction func closeButtonClick(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.txtName.resignFirstResponder() //收回keyboard
        }
    }
    
    @IBAction func OrderButtonClick(_ sender: Any) {
        guard txtName.text != "" else {
            Alert(msg: "名前を入力してください！")
            return
        }
        
        func convert(index: Int, converter: (Int) -> (String)) -> String {
            return converter(index)
        }
        
       
        
        //drinks size
        let size = convert(index: sizeSegmented.selectedSegmentIndex) { (index) -> String in
            if index == 0 {
                return "S"
            } else if index == 1 {
                return "M"
            } else {
                return "L"
            }
        }
        
        // 甜度
        let sweetness = convert(index: sugerSegmented.selectedSegmentIndex) { (index) -> String in
            switch(index) {
            case 1:
                return "0%"
            case 2:
                return "30%"
            case 3:
                return "50%"
            case 4:
                return "80%"
            default:
                return "100%"
            }
        }
        
        //ice
        let ice = convert(index: iceSegmented.selectedSegmentIndex) { (index) -> String in
            switch(index) {
            case 1:
                return "氷なし"
            case 2:
                return "氷少なめ"
            default:
                return "オリジナル"
            }
        }
        
        // Add peral
        let pearl = addSwitch.isOn ? "いる" : "なし"
        
        // 建立一筆訂單
//        let newOrder = Order(name: uname, drink: drinkName, size: size, sweetness: sweetness, ice: ice, peral: pearl)
        
        refreshView.startAnimating()
    }
    
    func Alert(msg:String) -> () {
        //宣告alert
        let alert = UIAlertController.init(title: nil, message: msg, preferredStyle: UIAlertController.Style.alert)
        //加按鈕
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //加到畫面
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}

