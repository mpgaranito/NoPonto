//
//  InterfaceController.swift
//  NoPonto WatchKit Extension
//
//  Created by Usuário Convidado on 31/08/19.
//  Copyright © 2019 GARANITO ME. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var textGroup: WKInterfaceGroup!
    @IBOutlet weak var imageGroup: WKInterfaceGroup!
    @IBOutlet weak var weightLabel: WKInterfaceLabel!
    @IBOutlet weak var cookLabel: WKInterfaceLabel!
    @IBOutlet weak var weightPicker: WKInterfacePicker!
    @IBOutlet weak var temperaturePicker: WKInterfacePicker!
    
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    
    @IBOutlet weak var slider: WKInterfaceSlider!
    @IBOutlet weak var timerButton: WKInterfaceButton!
    
    
    var kg: Double = 0.1
    var cookTemp = MeatTemperature.rare
    var timerRunning = false
    var increment = 0.1
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        imageGroup.setHidden(true)
        setupPickers()
        updateConfiguration()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func onMinusButton() {
        if kg > 0.1 {
            kg -= increment
            updateConfiguration()
        }
    }
    
    @IBAction func onPlusButton() {
        if kg < 1.0 {
            kg += increment
            updateConfiguration()
        }
    }
    
    @IBAction func onTempChange(_ value: Float) {
        if let temp = MeatTemperature(rawValue: Int(value)) {
            cookTemp = temp
            updateConfiguration()
            //Atualizando o outro painel
            temperaturePicker.setSelectedItemIndex(Int(value))
        }
    }
    
    @IBAction func onTimerButton() {
        if timerRunning {
            timer.stop()
            timerButton.setTitle("Start Timer")
        } else {
            let time = cookTemp.cookTimeForKg(kg)
            timer.setDate(Date(timeIntervalSinceNow: time))
            timer.start()
            timerButton.setTitle("Stop Timer")
        }
        timerRunning = !timerRunning
    }
    
    
    @IBAction func onWeightChange(_ value: Int) {
        kg = Double(value+1)*increment
        updateConfiguration()
    }
    
   
    @IBAction func onTemperatureChange(_ value: Int) {
        let temp = MeatTemperature(rawValue: value)!
        cookTemp = temp
        updateConfiguration()
        temperatureLabel.setText(temp.stringValue)
        //Atualizando o outro painel
        slider.setValue(Float(value))
    }
    @IBAction func onModeChange(_ value: Bool) {
        imageGroup.setHidden(!value)
        textGroup.setHidden(value)
        updateConfiguration()
    }
    
    
    //MARK: - Methods
    
    func setupPickers() {
        //Picker de quantidade
        var weightItems: [WKPickerItem] = []
        for i in stride(from: 0.1, through: 1.0, by: increment) {
            let item = WKPickerItem()
            item.title = "\(get2DecimalPlaces(for: i))"
            weightItems.append(item)
        }
        weightPicker.setItems(weightItems)
        weightPicker.setSelectedItemIndex(0)
        
        //Picker de temperatura
        var tempItems: [WKPickerItem] = []
        for i in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(i)")
            tempItems.append(item)
        }
        temperaturePicker.setItems(tempItems)
    }
    
    func get2DecimalPlaces(for number: Double) -> Double {
        return Double(round(100*number)/100)
    }
    
    func updateConfiguration() {
        cookLabel.setText(cookTemp.stringValue)
        kg = get2DecimalPlaces(for: kg)
        weightLabel.setText("Total: \(kg) kg")
    }
    
}


