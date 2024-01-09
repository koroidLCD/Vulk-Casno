

import UIKit
struct AnimationManager {
    
    static func buttonPressAnimation(sender: UIView) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        })
    }
    
    static func textChangeAnimation(sender: UILabel, newValue: Int) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.subtype = CATransitionSubtype.fromTop
        sender.text = String(newValue)
        animation.duration = 0.25
        sender.layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

struct DynamicConstraintsManager {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let designScreenWidth = 414
    private let designScreenHeight = 896
    
    func constraintPortrait(_ designConstraint: Int) -> CGFloat {
        CGFloat((designConstraint * Int(screenWidth)) / designScreenWidth)
    }
    
    func constraintLandscape(_ designConstraint: Int) -> CGFloat {
        CGFloat((designConstraint * Int(screenHeight)) / designScreenHeight)
    }
}
struct SlotsGameModel {
    let slotsPackImages: [String]
    let numberOfColumns: Int
}

struct K {
    struct BrandColors {
        static let bottomBG = "BottomBG"
        static let redStroke = "RedStroke"
        static let topBG = "TopBG"
        static let lightGrayText = "LightGrayText"
        static let greenLoader = "GreenLoader"
        static let lightGrayLoader = "LightGrayLoader"
    }
    
    struct Fonts {
        static let robotoBold = "AvenirNext-Heavy"
        static let sfProDisplayBold = "AvenirNext-Heavy"
        static let sfProDisplayRegular = "AvenirNext-Heavy"
    }
}

struct GameViewModel {
    
    lazy var gameSlotsPack = SlotsGameModel(slotsPackImages: [], numberOfColumns: 0)
    lazy var infoTitle = Box(String())
    lazy var currentMoney = Box(Int())
    lazy var currentLine = [Int]()
    lazy var currentRate = 50
    private var winAmount = Int()
    private var loseAmount = Int()
    let userMoney = UserMoney()
    
    func randomNumber() -> Int {
        return Int.random(in: 9...17)
    }
    
    mutating func makeBigSlotsArray() -> [String] {
        var bigSlotsArray = [String]()
        for _ in 1...3 {
            bigSlotsArray.append(contentsOf: gameSlotsPack.slotsPackImages)
        }
        return bigSlotsArray
    }
    
    mutating func setCurrentLine(_ slotIndex: Int) {
        currentLine.append(slotIndex)
    }
    
    mutating func slotsCheck() {
        let filter = Set(currentLine).count
        winAmount = 0
        loseAmount = 0
        switch filter {
        case 1:
            winAmount = currentRate * 5 // 5 из 5
        case 2:
            winAmount = currentRate * 2 // 4 из 5
        case 3:
            winAmount = currentRate // 3 из 5
        case 5:
            loseAmount = currentRate // 1 из 5
        default:
            break
        }
        infoTitleUpdate()
        userMoneyUpdate()
    }
    
    mutating private func infoTitleUpdate() {
        if winAmount != 0 {
            infoTitle.value = "WIN: +\(winAmount)"
        } else if loseAmount != 0 {
            infoTitle.value = "LOSE: \(loseAmount)"
        } else {
            infoTitle.value = "NO LOSS, NO WIN"
        }
    }
    
    mutating private func userMoneyUpdate() {
        var bank = userMoney.getUserMoney()
        if winAmount != 0 {
            bank += winAmount
        } else if loseAmount != 0 {
            bank -= loseAmount
        }
        userMoney.setUserMoney(value: bank)
        currentMoney.value = bank
    }
}


struct MainViewModel {
    private let slotsGames = [
        SlotsGameModel(slotsPackImages: ["Icon1.1", "Icon1.2", "Icon1.3", "Icon1.4", "Icon1.5", "Icon1.6", "Icon1.7", "Icon1.8", "Icon1.9"], numberOfColumns: 5),
        SlotsGameModel(slotsPackImages: ["Icon2.1", "Icon2.2", "Icon2.3", "Icon2.4", "Icon2.5", "Icon2.6", "Icon2.7", "Icon2.8", "Icon2.9"], numberOfColumns: 5),
        SlotsGameModel(slotsPackImages: ["Icon3.1", "Icon3.2", "Icon3.3", "Icon3.4", "Icon3.5", "Icon3.6", "Icon3.7", "Icon3.8", "Icon3.9"], numberOfColumns: 5)]
    
    func getSlotsPack(gameNumber: Int) -> SlotsGameModel {
        return slotsGames[gameNumber]
    }
}

final class Box<T> {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
