import Foundation

final class RewardsManager {
    static let shared = RewardsManager()
    
    func rewards() -> [Reward] {
        var userMoney = UserMoney()
        let res: [Reward] = [Reward(imageName: "reward1", title: "Collect 500 points", collected: false),
                             Reward(imageName: "reward2", title: "Collect 1000 points", collected: false),
                             Reward(imageName: "reward3", title: "Collect 10000 points", collected: false),
                             Reward(imageName: "reward4", title: "Collect 50000 points", collected: false)]
            if userMoney.getMax()  >= 500 {
                res[0].imageName = "reward1"
                res[0].title = "500 points collected!"
                res[0].collected = true
            }
            if userMoney.getMax()  >= 1000 {
                res[1].imageName = "reward2"
                res[1].title = "1000 points collected!"
                res[1].collected = true
            }
            if userMoney.getMax()  >= 10000 {
                res[2].imageName = "reward3"
                res[2].title = "10000 points collected!"
                res[2].collected = true
            }
            if userMoney.getMax()  >= 50000 {
                res[3].imageName = "reward4"
                res[3].title = "50000 points collected!"
                res[3].collected = true
            }
        
        return res
    }
}

final class Reward {
    var collected: Bool
    
    var imageName: String
    
    var title: String
    
    init(imageName: String, title: String, collected: Bool) {
        self.imageName = imageName
        self.title = title
        self.collected = collected
    }
}

import Foundation

struct UserMoney {
    private let defaults = UserDefaults.standard
    
    func setupUserMoney(){
        defaults.set(500, forKey: "userMoney")
    }
    
    func setMax() {
        if let retrievedValue = UserDefaults.standard.object(forKey: "userMoneyMax") as? Int {
            if getUserMoney() > retrievedValue {
                UserDefaults.standard.set(getUserMoney(), forKey: "userMoneyMax")
            }
        } else {
            UserDefaults.standard.set(getUserMoney(), forKey: "userMoneyMax")
        }
    }
    
    func getMax() -> Int {
        if let retrievedValue = UserDefaults.standard.object(forKey: "userMoneyMax") as? Int {
           return retrievedValue
        } else {
            return 0
        }
    }
    
    func setUserMoney(value: Int){
        defaults.set(value, forKey: "userMoney")
        setMax()
    }
    
    func getUserMoney() -> Int {
        defaults.integer(forKey: "userMoney")
    }
}
