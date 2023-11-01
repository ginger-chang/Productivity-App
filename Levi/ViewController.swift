//
//  ViewController.swift
//  Levi
//
//  Created by Ginger Chang on 12/12/22.
//

import UIKit
import Foundation

let userDefaults = UserDefaults.standard

public var pomodoroTimeToLeviDivider = 1
var timer: Timer?


class ViewController: UIViewController {

    //Shop
    @IBOutlet weak var currencyStatus: UILabel!
    //Pomodoro
    @IBOutlet weak var pomodoroProgressBar: UIProgressView!
    @IBOutlet weak var pomodoroButton: UIButton!
    @IBOutlet weak var pomodoroSlider: UISlider!
    @IBOutlet weak var pomodoroLabel: UILabel!
    @IBOutlet weak var pomodoroMessage: UILabel!
    @IBOutlet weak var extraTimeLabel: UILabel!
    //Shower Battle
    @IBOutlet weak var showerBattleButton: UIButton!
    @IBOutlet weak var showerBattleLabel: UILabel!
    //To-Do List
    @IBOutlet weak var toDoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateText()
        updateToDoText()
        //TODO: if pomodoro is running (status = 1), set pomodoro label & change button & set progress bar, etc. USING TIMER
        resetPomodoroTimer()
        resetShowerBattleMission()
        resetToDo()
    }
    
    /**
        TODAY'S TO-DO
     userDefaults: int "CompletedTasks," int "Task1Completion" "Task2Completion"... (1 for done, 0 for not done yet)
     userDefaults (updating / next day): int "ToDoLastUpdated"
     */
    
    public var taskToTickets = [2, 2, 4, 6, 10, 16, 26, 42]
    
    func resetToDo() {
        let lastUpdated = userDefaults.object(forKey: "ToDoLastUpdated")
        if (lastUpdated == nil || !Calendar.current.isDateInToday(lastUpdated as! Date)) {
            for i in 1...6 {
                userDefaults.set(0, forKey: "Task" + String(i) + "Completion")

            }
            userDefaults.set(0, forKey: "CompletedTasks")
            userDefaults.set(Date(), forKey: "ToDoLastUpdated")
        }
    }
    
    @IBAction func task1(_ sender: Any) {
        alertTask(id: 1)
    }
    
    @IBAction func task2(_ sender: Any) {
        alertTask(id: 2)
    }
    
    @IBAction func task3(_ sender: Any) {
        alertTask(id: 3)
    }
    
    @IBAction func task4(_ sender: Any) {
        alertTask(id: 4)
    }
    
    @IBAction func task5(_ sender: Any) {
        alertTask(id: 5)
    }
    
    @IBAction func task6(_ sender: Any) {
        alertTask(id: 6)
    }
    
    func completeTask(id: Int) {
        print("complete task " + String(id))
        userDefaults.set(1, forKey: "Task" + String(id) + "Completion")
        let completed = userDefaults.integer(forKey: "CompletedTasks")
        addLeviMoney(levi: taskToTickets[completed], money: 0.0)
        userDefaults.set(completed + 1, forKey: "CompletedTasks")
        updateToDoText()
    }
    
    func alertTask(id: Int) {
        let taskCompletion = userDefaults.integer(forKey: "Task" + String(id) + "Completion")
        if (taskCompletion == 1) {
            let alert = UIAlertController(title: "Not again...", message: "You've already finished this task and claimed your reward.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ah shoot, my bad.", comment: "Default action"), style: .default, handler: { _ in
                self.cancel()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Confirm completion", message: "Have you completed the task?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
                self.completeTask(id: id)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .cancel, handler: { _ in
                self.cancel()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateToDoText() {
        let completed = userDefaults.integer(forKey: "CompletedTasks")
        toDoLabel?.text = "You've completed " + String(completed) + " task(s) today.\nYou will earn " + String(taskToTickets[completed]) + " tickets for the next task."
    }
    
    /**
        SHOWER BATTLE
     */
    
    func resetShowerBattleMission() {
        var showerDate = userDefaults.object(forKey:"showerDate")
        if (showerDate == nil) { //nothing exists
            let showerDate = Date()
            generateTimeAndReward()
        } else { //there is something
            showerDate = UserDefaults.standard.value(forKey:"showerDate") as! Date
            let today = Date()
            let calendar = Calendar.current
            //let yesterdayFour = calendar.date(bySettingHour: 4, minute: 0, second: 0, of: yesterdayFour)!
            let todayFour = calendar.date(bySettingHour: 4, minute: 0, second: 0, of: today)!
            if (Date() < todayFour) {
                //var leftBound =
                var rightBound = todayFour
            }
        }
        let h = userDefaults.integer(forKey: "showerHour")
        let m = userDefaults.integer(forKey: "showerMinute")
        let r = userDefaults.integer(forKey: "showerReward")
        showerBattleLabel?.text = "Todays' mission: go to shower before" + "\r\n" + String(format: "%02d", h) + ":" + String(format: "%02d", m) + " to earn \(r) tickets!"
    }
    
    func generateTimeAndReward(){
        var a = Int.random(in: 19...23)
        var b = Int.random(in: 0...59)
        var c = 24 - a
        userDefaults.set(a, forKey: "showerHour")
        userDefaults.set(b, forKey: "showerMinute")
        userDefaults.set(c, forKey: "showerReward")
        userDefaults.set(Date(), forKey: "showerDate")
    }
    
    @IBAction func showerButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Going to shower?", message: "Don't lie to me.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            self.showerConfirmed()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .cancel, handler: { _ in
            self.cancel()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showerConfirmed() {
        showerBattleLabel?.text = "You smell good!!!"
        showerBattleButton?.setTitle("Good job :)", for: .normal)
        addLeviMoney(levi: userDefaults.integer(forKey: "showerReward"), money: 0.0)
        showerBattleButton.isEnabled = false;
    }
    
    
    /**
        POMODORO
     */
    
    func resetPomodoroTimer() {
        var finishSession = false
        var pomodoroStatus = userDefaults.bool(forKey: "pomodoroStatus")
        
        if (pomodoroStatus) {
            let pomodoroEnd = userDefaults.object(forKey:"pomodoroEnd") as! Date
            if (Date() > pomodoroEnd) { //double check
                pomodoroStatus = false
                userDefaults.set(false, forKey: "pomodoroStatus")
                finishSession = true
            } else { //ongoing pomodoro
                startFrameTimer()
                pomodoroButton?.setTitle("Cancel Timer", for: .normal)
                return
            }
        }
         //no pomodoro
        pomodoroButton?.setTitle("Start Timer", for: .normal)
        pomodoroSlider?.setValue(25, animated: true)
        pomodoroLabel?.text = "25:00"
        if(finishSession) {
            pomodoroMessage?.text = "you just finished a session yeah"
            timerEnd()
        
        }
    }
    
    /* Updates slide timer 25:00 */
    @IBAction func slide(_ sender: Any) {
        let pomodoroStatus = userDefaults.bool(forKey: "pomodoroStatus")
        if (pomodoroStatus == false){
            let value = Int(pomodoroSlider.value)
            pomodoroLabel?.text = String(format: "%02d", value) + ":00"
        }
        //print("Sliding")
    }
    
    /* TODO: THIS IS BROKEN URGH
     Updates pomodoro message*/
    
    @IBAction func letGoSlider(_ sender: UISlider) {
        let pomodoroStatus = userDefaults.bool(forKey: "pomodoroStatus")
        if (pomodoroStatus == false){
            let value = Int(pomodoroSlider.value)
            pomodoroMessage?.text = "After " +  String(value) + " minutes of study, you'll earn " + String(value / pomodoroTimeToLeviDivider) + " tickets! (And maybe some bonus too~)"
        }
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        var pomodoroStatus = userDefaults.bool(forKey: "pomodoroStatus")
        if (pomodoroStatus == false) {
            pomodoroStatus = true
            userDefaults.set(pomodoroStatus, forKey: "pomodoroStatus")
            let value = Int(pomodoroSlider.value)
            let timeInterval = TimeInterval(value * 60)
            let pomodoroStart = Date()
            let pomodoroEnd = pomodoroStart + timeInterval
            pomodoroLabel?.text = String(format: "%02d", value - 1) + ":59"
            pomodoroButton?.setTitle("Cancel Timer", for: .normal)
            userDefaults.set(pomodoroEnd, forKey: "pomodoroEnd")
            userDefaults.set(Double(timeInterval), forKey: "pomodoroTime")
            
            startFrameTimer()
            //(Repeat) update: cur time & label & progress bar
                // using timer object
            //end: call end function
        } else {
            confirmCancelTimer()
            
        }
    }
    
    func startFrameTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        print("tick")
        let pomodoroEnd = userDefaults.object(forKey:"pomodoroEnd") as! Date
        let pomodoroTime = userDefaults.double(forKey: "pomodoroTime")
        
        let timeInterval = Int(pomodoroEnd.timeIntervalSinceNow)
        let second = timeInterval % 60
        let minute = timeInterval / 60
        let progress = Double(timeInterval) / Double(pomodoroTime)
        pomodoroLabel?.text = String(format: "%02d", minute) + ":" + String(format: "%02d", second)
        pomodoroProgressBar?.setProgress(Float(1.0 - progress), animated: true)
        if (second == 0 && minute == 0) {
            userDefaults.set(false, forKey: "pomodoroStatus")
            timer?.invalidate()
            timerEnd() //calculates levi and stuff
            resetPomodoroTimer()
        }
        
    }
    
    func cancelTimer() {
        let pomodoroStatus = false
        //TODO: punishment
        userDefaults.set(pomodoroStatus, forKey: "pomodoroStatus")
        pomodoroButton?.setTitle("Start Timer", for: .normal)
        timer?.invalidate()
        resetPomodoroTimer()
    }
    
    func confirmCancelTimer(){
        let alert = UIAlertController(title: "Stop Timer?", message: "You will be punished if you cancel the timer before it ends.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Default action"), style: .default, handler: { _ in
            self.cancelTimer()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            self.cancel()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func timerEnd() {
        //reset timer?
        //message change
        //add levi - bonus
        print("pomodoro session has ended")
        let earnedLevi = userDefaults.integer(forKey: "pomodoroTime") / 60 / pomodoroTimeToLeviDivider
        addLeviMoney(levi: earnedLevi, money: 0.0)
        pomodoroMessage?.text = "Congratulations! The session have ended, and you will earn " + String(earnedLevi) + " tickets!"
        resetPomodoroTimer()
    }
    
    /**
        SHOP
     */
    
    @IBAction func add10Levi(_ sender: Any) {
        addLeviMoney(levi: 10, money: 0.0)
    }
    
    @IBAction func add3AB(_ sender: Any) {        addLeviMoney(levi: 0, money: 3.0)
    }
    func addLeviMoney(levi: Int, money: Double) {
        let curLevi = userDefaults.integer(forKey: "Levi") + levi
        let curMoney = userDefaults.double(forKey: "Money") + money
        print("+" + String(curLevi) + " levi, + " + String(curMoney) + "$")
        userDefaults.set(curLevi, forKey: "Levi")
        userDefaults.set(curMoney, forKey: "Money")
        print("cur levi: " + String(userDefaults.integer(forKey: "Levi")))
        updateText()
    }
    
    func clickPurchase(shopItem: ShopItem) {
        var spend = String(shopItem.levi) + " Levi "
        if (shopItem.money != 0) {
                spend += "and " + String(shopItem.money) + "$ "
        }
        let alert = UIAlertController(title: "Confirm Purchase", message: "You're trading " + spend + "for " + shopItem.getFullName() + ".", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            self.cancel()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Default action"), style: .default, handler: { _ in
            self.purchase(shopItem: shopItem)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancel() {
        print("Nothing happened lol.")
    }
    
    @IBAction func tenMinYt(_ sender: Any) {
        let shopItem = ShopItem(levi: 30, money: 0, name: "Youtube", count: 10, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func twentyMinYt(_ sender: Any) {
        let shopItem = ShopItem(levi: 55, money: 0, name: "Youtube", count: 20, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func thirtyMinYt(_ sender: Any) {
        let shopItem = ShopItem(levi: 80, money: 0, name: "Youtube", count: 30, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func movie(_ sender: Any) {
        let shopItem = ShopItem(levi: 200, money: 0, name: "Movie", count: 1, unit: "count")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func tvSeries(_ sender: Any) {
        let shopItem = ShopItem(levi: 120, money: 0, name: "TV Series", count: 1, unit: "count")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func musicVideo(_ sender: Any) {
        let shopItem = ShopItem(levi: 20, money: 0, name: "Music Video", count: 1, unit: "count")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func oneChocolate(_ sender: Any) {
        let shopItem = ShopItem(levi: 60, money: 0.2, name: "Chocolate", count: 1, unit: "piece")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func twoChocolate(_ sender: Any) {
        let shopItem = ShopItem(levi: 100, money: 0.4, name: "Chocolate", count: 2, unit: "piece")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func tenMinSnackTime(_ sender: Any) {
        let shopItem = ShopItem(levi: 100, money: 1.0, name: "Snack Time", count: 10, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func twoMinArknights(_ sender: Any) {
        let shopItem = ShopItem(levi: 20, money: 0, name: "Arknights", count: 2, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func twentyMinArknights(_ sender: Any) {
        let shopItem = ShopItem(levi: 120, money: 0, name: "Arknights", count: 20, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    @IBAction func twentyMinGameTime(_ sender: Any) {
        let shopItem = ShopItem(levi: 140, money: 0, name: "Game Time", count: 20, unit: "min")
        clickPurchase(shopItem: shopItem)
    }
    
    func purchase(shopItem: ShopItem) {
        if (checkBalance(shopItem: shopItem)) {
            let curLevi = userDefaults.integer(forKey: "Levi") - shopItem.levi
            let curMoney = userDefaults.double(forKey: "Money") - shopItem.money
            userDefaults.set(curLevi, forKey: "Levi")
            userDefaults.set(curMoney, forKey: "Money")
            updateText()
        }
    }
    
    func checkBalance(shopItem: ShopItem) -> Bool{
        let curLevi = userDefaults.integer(forKey: "Levi")
        let curMoney = userDefaults.double(forKey: "Money")
        if (shopItem.levi > curLevi || shopItem.money > curMoney) {
            print("broke")
            let alert = UIAlertController(title: "You broke man.", message: "Sad but true.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("I'm so sorry", comment: "Default action"), style: .default, handler: { _ in
                self.cancel()
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        print("not broke")
        return true
    }
    
    func updateText() {
        //TODO: update text and numbers into user default
        let curLevi = userDefaults.integer(forKey: "Levi")
        let curMoney = userDefaults.double(forKey: "Money")
        currencyStatus?.text = "Your current tickets: " + String(curLevi) + "\r\nYour actual balance: " + String(format: "%.1f", curMoney)
    }
    
    
}

