//
//  ViewController.swift
//  Currency converter
//
//  Created by Захар on 12.06.17.
//  Copyright © 2017 Захар. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var namesOfCurrency = [String]()
    var valuesofCurrencyBasedEUR = [Double]()
    var selectedInputCurrency = Double()
    var selectedOutputCurrency = Double()
    
    @IBOutlet weak var selectCurrencyField: UITextField!
    @IBOutlet weak var inputCurrencyLabel: UILabel!
    @IBOutlet weak var outputCurrencyLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var outputField: UITextField!
    
    @IBAction func convertButton(_ sender: UIButton) {
        if !(inputField.text?.isEmpty)! {
            if !(checkForLetters(number: (inputField.text))) {
                convertMoney()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getRate()
        createPickerView()
        createToolBar()
    }
    
    func getRate() {
        let url = URL(string: "https://api.fixer.io/latest")
        
        getData(url: url)
    }
    
    func getData(url: URL!) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if data != nil {
                    do {
                        let jsonOfData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let rates = jsonOfData["rates"] as? NSDictionary {
                            self.namesOfCurrency = rates.allKeys as! [String]
                            self.valuesofCurrencyBasedEUR = rates.allValues as! [Double]
                            self.namesOfCurrency.append("EUR")
                            self.valuesofCurrencyBasedEUR.append(1)
                        }
                    } catch {}
                }
            }
        }
        task.resume()
    }
    
    func createPickerView() {
        
        let currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        
        selectCurrencyField.inputView = currencyPicker
        currencyPicker.backgroundColor = .white
    }
    
    func createToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        selectCurrencyField.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func convertMoney() {
        var rateOfThisCurrency = Double()
        var result = Double()
        
        if  selectedInputCurrency > selectedOutputCurrency {
            rateOfThisCurrency = selectedInputCurrency / selectedOutputCurrency
            result = Double(inputField.text!)! / rateOfThisCurrency
            
        } else if selectedInputCurrency < selectedOutputCurrency{
            rateOfThisCurrency = selectedOutputCurrency / selectedInputCurrency
            result = Double(inputField.text!)! * rateOfThisCurrency
        }
        
        outputField.text = String(result)
    }
    
    func checkForLetters(number: String?) -> Bool {
        if Double(number!) == nil {
            return true
        }
        return false
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return namesOfCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return namesOfCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedInputCurrency = valuesofCurrencyBasedEUR[row]
            inputCurrencyLabel.text = namesOfCurrency[row]
        } else {
            selectedOutputCurrency = valuesofCurrencyBasedEUR[row]
            outputCurrencyLabel.text = namesOfCurrency[row]
        }
    }
}



