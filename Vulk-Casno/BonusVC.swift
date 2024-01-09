import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var level: gameLevel!
    
    var runes: [Rune] = []
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    let cellIdentifier = "cell"
    let numberOfSections = 4
    let numberOfItemsInEachSection = 4
    
    var currentRune: Rune! {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.currentRuneImage.image = self.currentRune.image
            })
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var currentRuneImage: UIImageView!
    
    var collectionView: UICollectionView!
    
    var timer: Timer?
    
    var secondsRemaining: Double = 25
    var squareViews: [UIView] = []
    var stackView: UIStackView!
    
    //MARK: - setupTimer
    func setupTimer() {
         stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 10
                stackView.distribution = .fillEqually
                stackView.translatesAutoresizingMaskIntoConstraints = false

                for i in 0..<25 {
                    let squareView = UIView()
                    squareView.clipsToBounds = true
                    squareView.layer.cornerRadius = 5
                    squareView.tag = i
                    squareView.backgroundColor = (i < Int(secondsRemaining)) ? .cyan : .gray
                    squareView.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(squareView)
                    squareViews.append(squareView)
                }

                view.addSubview(stackView)

                NSLayoutConstraint.activate([
                    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                    stackView.heightAnchor.constraint(equalToConstant: 50),
                    stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95)
                ])
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //MARK: - updateTimer
    @objc func updateTimer() {
        secondsRemaining -= 1
        for i in self.squareViews {
            i.backgroundColor = (i.tag < Int(self.secondsRemaining)) ? .cyan : .gray
        }
        if secondsRemaining <= 0 {
            timer?.invalidate()
            collectionView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.collectionView.alpha = 0
                    self.currentRuneImage.alpha = 0
                    self.stackView.alpha = 0
                }) { _ in
                    let jokerImageView = UIImageView()
                    jokerImageView.image = UIImage(named: "logo")
                    jokerImageView.contentMode = .scaleAspectFit
                    jokerImageView.translatesAutoresizingMaskIntoConstraints = false
                    jokerImageView.alpha = 0
                    let loseImageView = UIImageView()
                    loseImageView.image = UIImage(named: "lose")
                    loseImageView.contentMode = .scaleAspectFit
                    loseImageView.alpha = 0
                    loseImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(loseImageView)
                    self.view.addSubview(jokerImageView)
                    
                    let restartButton = UIButton(type: .custom)
                    restartButton.setImage(UIImage(named: "btn_restart"), for: .normal)
                    restartButton.imageView?.contentMode = .scaleAspectFit
                    restartButton.alpha = 0
                    restartButton.translatesAutoresizingMaskIntoConstraints = false
                    restartButton.addAction(UIAction(handler: {_ in
                        self.restart()
                        loseImageView.removeFromSuperview()
                        jokerImageView.removeFromSuperview()
                        restartButton.removeFromSuperview()
                    }), for: .touchUpInside)
                    self.view.addSubview(restartButton)
                    
                    NSLayoutConstraint.activate([
                        restartButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
                        restartButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                        restartButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
                        restartButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
                    ])
                    NSLayoutConstraint.activate([
                        jokerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        jokerImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        jokerImageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                        jokerImageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1),
                        
                        loseImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        loseImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                        loseImageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                        loseImageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
                    ])
                    UIView.animate(withDuration: 0.5, animations: {
                        jokerImageView.alpha = 1
                        loseImageView.alpha = 1
                        restartButton.alpha = 1
                    })
                }
            })
        }
    }
    
    func loadImages() {
        for i in 1...16 {
            runes.append(Rune(image: UIImage(named: "item_\(i)")!, id: i))
        }
        runes.shuffle()
        currentRune = runes.randomElement()
    }
    
    func restart() {
        runes = []
        squareViews = []
        secondsRemaining = 25
        setupCollectionView()
        setupTimer()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupCollectionView()
        setupTimer()
    }
    
    func setupBackground() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleToFill
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "btn_back"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addAction(UIAction(handler: {_ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
            backButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
        ])
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width*0.8 - 12 - 1) / 4, height: (view.frame.width*0.8 - 12 - 1) / 4)
        layout.minimumInteritemSpacing = 4
        
        currentRuneImage = UIImageView()
        currentRuneImage.translatesAutoresizingMaskIntoConstraints = false
        currentRuneImage.contentMode = .scaleAspectFit
        view.addSubview(currentRuneImage)
        
        loadImages()
        
        NSLayoutConstraint.activate([
            currentRuneImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentRuneImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            currentRuneImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            currentRuneImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)
        ])
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 10
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInEachSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.setupRune(runes[indexPath.section * 4 + indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        if cell.id == currentRune.id {
            cell.id = 0
            for i in 0...runes.count-1 {
                if runes[i].id == currentRune.id {
                    runes.remove(at: i)
                    break
                }
            }
            if level == .easy {
                UIView.animate(withDuration: 0.2, animations: {
                    cell.imageView.image = UIImage(named: "crash")
                })
            }
        } else if level == .hard {
            secondsRemaining -= 3
            for i in self.squareViews {
                i.backgroundColor = (i.tag < Int(self.secondsRemaining)) ? .cyan : .gray
            }
        }
        if !runes.isEmpty {
            currentRune = runes.randomElement()
        } else {
            timer?.invalidate()
            var userMoney = UserMoney()
            userMoney.setUserMoney(value: userMoney.getUserMoney() + 50)
            collectionView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.collectionView.alpha = 0
                    self.currentRuneImage.alpha = 0
                    self.stackView.alpha = 0
                }) { _ in
                    let jokerImageView = UIImageView()
                    jokerImageView.image = UIImage(named: "logo")
                    jokerImageView.contentMode = .scaleAspectFit
                    jokerImageView.translatesAutoresizingMaskIntoConstraints = false
                    jokerImageView.alpha = 0
                    self.view.addSubview(jokerImageView)
                    let winImageView = UIImageView()
                    winImageView.image = UIImage(named: "win")
                    winImageView.contentMode = .scaleAspectFit
                    winImageView.alpha = 0
                    winImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(winImageView)
                    
                    let restartButton = UIButton(type: .custom)
                    restartButton.setImage(UIImage(named: "btn_restart"), for: .normal)
                    restartButton.imageView?.contentMode = .scaleAspectFit
                    restartButton.alpha = 0
                    restartButton.translatesAutoresizingMaskIntoConstraints = false
                    restartButton.addAction(UIAction(handler: {_ in
                        self.restart()
                        winImageView.removeFromSuperview()
                        jokerImageView.removeFromSuperview()
                        restartButton.removeFromSuperview()
                    }), for: .touchUpInside)
                    self.view.addSubview(restartButton)
                    
                    NSLayoutConstraint.activate([
                        restartButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
                        restartButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                        restartButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
                        restartButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
                    ])
                    
                    NSLayoutConstraint.activate([
                        jokerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        jokerImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        jokerImageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                        jokerImageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1),
                        
                        winImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        winImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                        winImageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                        winImageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
                    ])
                    UIView.animate(withDuration: 0.5, animations: {
                        jokerImageView.alpha = 1
                        winImageView.alpha = 1
                        restartButton.alpha = 1
                    })
                }
            })
        }
        animateCellSwap()
    }
  

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        } else if section == 3 {
            return UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        }
    }
    
    func animateCellSwap() {
        for i in 0...3 {
            for j in 0...3 {
                let indexPath = IndexPath(row: j, section: i)
                let randomIndexPath = IndexPath(item: Int.random(in: 0..<numberOfItemsInEachSection), section: Int.random(in: 0..<numberOfSections))
                
                UIView.animate(withDuration: 0.5) {
                    self.collectionView.performBatchUpdates({
                        self.collectionView.moveItem(at: indexPath, to: randomIndexPath)
                        self.collectionView.moveItem(at: randomIndexPath, to: indexPath)
                    }, completion: { _ in
                    })
                }
            }
        }
    }
    
    
}
class CustomCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var id: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRune(_ rune: Rune){
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        imageView.image = rune.image
        id = rune.id
    }
    
}

final class Rune {
    
    var image: UIImage
    
    var id: Int
    
    init(image: UIImage, id: Int) {
        self.image = image
        self.id = id
    }
}

enum gameLevel {
    case easy
    case medium
    case hard
}
