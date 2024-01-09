import UIKit

class GameVC: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private let mainBackground = UIImageView()
    private let homeButton = UIButton()
    private let chestIcon = UIImageView()
    private let moneyLabel = UILabel()
    private let moneyImage = UIImageView()
    private let spinButton = UIButton()
    private let customStepper = CustomStepper()
    private let resultLabel = UILabel()
    private let slotsPicker = UIPickerView()
    
    private let dynamic = DynamicConstraintsManager()
    lazy var viewModel = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        slotsPicker.dataSource = self
        slotsPicker.delegate = self
        setupBackgrounds()
        setupMoneySection()
        setupStepper()
        setupSlotsPicker()
        setupResultLabel()
        setupSpinButton()
        setupHomeButton()
        bindViewModel()
    }
    
    private func setupBackgrounds() {
        mainBackground.image = UIImage(named: "background")
        
        view.addSubview(mainBackground)
        
        mainBackground.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainBackground.topAnchor.constraint(equalTo: view.topAnchor),
            mainBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupMoneySection() {
        view.addSubview(chestIcon)
        view.addSubview(moneyImage)
        view.addSubview(moneyLabel)
        chestIcon.translatesAutoresizingMaskIntoConstraints = false
        moneyImage.translatesAutoresizingMaskIntoConstraints = false
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chestIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: dynamic.constraintLandscape(20)),
            chestIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chestIcon.widthAnchor.constraint(equalToConstant: dynamic.constraintLandscape(115)),
            chestIcon.heightAnchor.constraint(equalToConstant: dynamic.constraintLandscape(97)),
            
            moneyImage.topAnchor.constraint(equalTo: chestIcon.bottomAnchor, constant: 8),
            moneyImage.centerXAnchor.constraint(equalTo: chestIcon.centerXAnchor),
            moneyImage.heightAnchor.constraint(equalToConstant: 30),
            moneyImage.widthAnchor.constraint(equalToConstant: dynamic.constraintLandscape(170)),
            
            moneyLabel.topAnchor.constraint(equalTo: chestIcon.bottomAnchor, constant: 8),
            moneyLabel.centerXAnchor.constraint(equalTo: chestIcon.centerXAnchor),
            moneyLabel.heightAnchor.constraint(equalToConstant: 30),
            moneyLabel.widthAnchor.constraint(equalToConstant: dynamic.constraintLandscape(170)),
        ])
        
        moneyImage.contentMode = .scaleToFill
        moneyImage.image = UIImage(named: "moneyImage")
        
        moneyLabel.text = String(viewModel.userMoney.getUserMoney())
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont(name: K.Fonts.robotoBold, size: 22)
        moneyLabel.textColor = .white
        chestIcon.contentMode = .scaleAspectFit
        chestIcon.image = UIImage(named: "logo")
    }
    
    private func setupSpinButton() {
        view.addSubview(spinButton)
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinButton.widthAnchor.constraint(equalToConstant: 150),
            spinButton.heightAnchor.constraint(equalToConstant: 150),
            spinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        spinButton.setImage(UIImage(named: "SpinIcon"), for: .normal)
        spinButton.addTarget(target, action: #selector(spinButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func spinButtonPressed(_ sender: UIButton) {
        for i in 0..<viewModel.gameSlotsPack.numberOfColumns {
            slotsPicker.selectRow((viewModel.randomNumber()), inComponent: i, animated: true)
            viewModel.setCurrentLine(slotsPicker.selectedRow(inComponent: i))
        }
        viewModel.slotsCheck()
        AnimationManager.buttonPressAnimation(sender: sender)
        viewModel.currentLine = []
    }
    
    private func setupStepper() {
        view.addSubview(customStepper)
        customStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customStepper.heightAnchor.constraint(equalToConstant: dynamic.constraintLandscape(33)),
            customStepper.topAnchor.constraint(equalTo: moneyLabel.bottomAnchor, constant: 30),
            customStepper.centerXAnchor.constraint(equalTo: moneyLabel.centerXAnchor)
        ])
        customStepper.maxValue = viewModel.userMoney.getUserMoney()
    }
    
    private func setupSlotsPicker() {
        
        let barabanView = UIImageView()
        barabanView.contentMode = .scaleToFill
        barabanView.translatesAutoresizingMaskIntoConstraints = false
        barabanView.image = UIImage(named: "baraban")
        view.addSubview(barabanView)
        view.addSubview(slotsPicker)
        slotsPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slotsPicker.topAnchor.constraint(equalTo: customStepper.bottomAnchor, constant: 10),
            slotsPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            slotsPicker.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            slotsPicker.heightAnchor.constraint(equalToConstant: 290),
            barabanView.topAnchor.constraint(equalTo: customStepper.bottomAnchor, constant: 10),
            barabanView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            barabanView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            barabanView.heightAnchor.constraint(equalToConstant: 290)
            
        ])
        
        slotsPicker.isUserInteractionEnabled = false
        
        for i in 0..<slotsPicker.numberOfComponents {
            slotsPicker.selectRow(viewModel.randomNumber(), inComponent: i, animated: true)
        }
    }
    
    private func setupResultLabel() {
        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: slotsPicker.bottomAnchor, constant: 10),
            resultLabel.centerXAnchor.constraint(equalTo: slotsPicker.centerXAnchor),
            resultLabel.heightAnchor.constraint(equalToConstant: 97)
        ])
        resultLabel.text = "LET'S SPIN!"
        resultLabel.font = UIFont(name: K.Fonts.robotoBold, size: 22)
        resultLabel.textColor = .white
    }
    
    private func setupHomeButton() {
        homeButton.setImage(UIImage(named: "btn_back"), for: .normal)
        homeButton.imageView?.contentMode = .scaleAspectFit
        homeButton.addTarget(target, action: #selector(homeButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(homeButton)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            homeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            homeButton.heightAnchor.constraint(equalToConstant: 40),
            homeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func homeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func bindViewModel() {
        viewModel.infoTitle.bind { infoTitle in
            DispatchQueue.main.async {
                self.resultLabel.text = infoTitle
            }
        }
        
        viewModel.currentMoney.bind { newValue in
            DispatchQueue.main.async {
                AnimationManager.textChangeAnimation(sender: self.moneyLabel, newValue: newValue)
                self.customStepper.maxValue = newValue
            }
        }
        
        customStepper.value.bind { newValue in
            self.viewModel.currentRate = newValue
        }
    }
    
}

extension GameVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.gameSlotsPack.numberOfColumns
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.gameSlotsPack.slotsPackImages.count * 3
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat { (UIScreen.main.bounds.width-30)/5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { UIScreen.main.bounds.width/5
    }
}
extension GameVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerView = UIView()
        let pickerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5))
        pickerImageView.image = UIImage(named: (viewModel.makeBigSlotsArray()[row]))
        pickerImageView.contentMode = .scaleAspectFit
        pickerView.addSubview(pickerImageView)
        return pickerView
    }
}
