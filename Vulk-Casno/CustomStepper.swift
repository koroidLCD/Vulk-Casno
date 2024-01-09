import UIKit

final class CustomStepper: UIView {
    lazy var value = Box(Int())
    lazy var maxValue = Int()
    
    private let decreaseButton = UIButton()
    private let increaseButton = UIButton()
    private let valueLabel = UILabel()
    private let dynamic = DynamicConstraintsManager()
    private let labelImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupApperence()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupApperence()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupApperence() {
        value.value = 50
        decreaseButton.setImage(UIImage(named: "btn_previous"), for: .normal)
        decreaseButton.imageView?.contentMode = .scaleAspectFit
        increaseButton.setImage(UIImage(named: "btn_next"), for: .normal)
        increaseButton.imageView?.contentMode = .scaleAspectFit

        decreaseButton.addTarget(target, action: #selector(keyPressed(_:)), for: .touchUpInside)
        increaseButton.addTarget(target, action: #selector(keyPressed(_:)), for: .touchUpInside)
        
        self.addSubview(decreaseButton)
        self.addSubview(increaseButton)
        self.addSubview(labelImage)
        self.addSubview(valueLabel)
        
        setupButton(button: decreaseButton)
        setupButton(button: increaseButton)
        setupLabel(label: valueLabel)
        
        NSLayoutConstraint.activate([
            decreaseButton.topAnchor.constraint(equalTo: self.topAnchor),
            decreaseButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            decreaseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            increaseButton.topAnchor.constraint(equalTo: self.topAnchor),
            increaseButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            increaseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: self.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -8),
            labelImage.topAnchor.constraint(equalTo: self.topAnchor),
            labelImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelImage.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 8),
            labelImage.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -8),
        ])
    }
    
    private func setupLabel(label: UILabel) {
        labelImage.translatesAutoresizingMaskIntoConstraints = false
        labelImage.image = UIImage(named: "btn_7")
        labelImage.contentMode = .scaleToFill
        labelImage.heightAnchor.constraint(equalToConstant: dynamic.constraintLandscape(33)).isActive = true
        labelImage.widthAnchor.constraint(equalToConstant: dynamic.constraintLandscape(88)).isActive = true
        label.text = String(value.value)
        label.textColor = .white
        label.font = UIFont(name: K.Fonts.robotoBold, size: dynamic.constraintLandscape(22))
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: dynamic.constraintLandscape(33)).isActive = true
        label.widthAnchor.constraint(equalToConstant: dynamic.constraintLandscape(88)).isActive = true
    }
    
    private func setupButton(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: dynamic.constraintLandscape(33)).isActive = true
        button.heightAnchor.constraint(equalToConstant: dynamic.constraintLandscape(33)).isActive = true
    }
    
    @objc private func keyPressed(_ sender: UIButton) {
        AnimationManager.buttonPressAnimation(sender: sender)
        switch sender {
        case increaseButton where value.value == maxValue:
            break
        case increaseButton:
            value.value += 50
        case decreaseButton where value.value == 0:
            break
        case decreaseButton:
            value.value -= 50
        default:
            return
        }
        valueLabel.text = String(value.value)
    }
}


import UIKit

// расширение для UIStackView с настройкой внешнего вида и возможностью при объявлении сразу указывать ему направление
extension UIStackView {
    convenience init ( arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 1, distribution: UIStackView.Distribution = .fillEqually) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
    }
}

