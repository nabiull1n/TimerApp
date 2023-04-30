//
//  TimerViewController.swift
//  TimerApp
//
//  Created by Денис Набиуллин on 19.04.2023.
//

import UIKit
import AVFoundation

final class TimerViewController: UIViewController {
    private var timer = Timer()
    private var player = AVAudioPlayer()
    private let shapeLayer = CAShapeLayer()
    private var modifiedTimer = 60
    private var currentStrokeEnd: CGFloat = 0.0
    private var durationTimer = 60
    private var isTransition = false
    
    private let pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.textColor = .lightGray
        picker.datePickerMode = .countDownTimer
        picker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.isHidden = true
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(named: "circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let startButton: CustomButton = {
        let button = CustomButton(title: "Start", titleColor: .green, backColor: .systemGreen)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton(title: "Cancel", titleColor: .gray, backColor: .darkGray)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let fartherButton: CustomButton = {
        let button = CustomButton(title: "Farther", titleColor: .green, backColor: .systemGreen)
        button.isHidden = true
        button.addTarget(self, action: #selector(fartherButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pauseButton: CustomButton = {
        let button = CustomButton(title: "Pause", titleColor: .orange, backColor: .brown)
        button.isHidden = true
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stopAlarmButton: CustomButton = {
        let button = CustomButton(title: "Stop", titleColor: .white, backColor: .systemRed)
        button.isHidden = true
        button.addTarget(self, action: #selector(stopAlarmButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTransition = true
    }
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isTransition {
            let number = Double(durationTimer)  / Double(modifiedTimer)
            animationCircular(strokeEnd: CGFloat(number))
            currentStrokeEnd = number
            showBasicAnimation()
        }
    }
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(shapeView)
        view.addSubview(pickerView)
        shapeView.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(pauseButton)
        view.addSubview(fartherButton)
        view.addSubview(stopAlarmButton)
        view.addSubview(cancelButton)
    }
    
    private func trueIsHiddenButton() {
        shapeView.isHidden = true
        timerLabel.isHidden = true
        fartherButton.isHidden = true
        pauseButton.isHidden = true
    }
    
    private func animationCircular(strokeEnd: CGFloat) {
        let center = CGPoint(x: shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 133.3,
                                        startAngle: endAngle,
                                        endAngle:  startAngle,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 32.7
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeView.layer.addSublayer(shapeLayer)
    }
    
    private func showBasicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        if currentStrokeEnd != 0 {
            basicAnimation.fromValue = currentStrokeEnd
        }
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "radar", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
        player.numberOfLoops = -1
        player.play()
    }
}
// MARK: - extension TimerViewController: @objc
private extension TimerViewController {
    @objc func dateChanged(sender: UIDatePicker) {
        print(sender.countDownDuration)
        durationTimer = Int(sender.countDownDuration)
        modifiedTimer = Int(sender.countDownDuration)
    }
    
    @objc func cancelButtonTapped() {
        cancelButton.setTitleColor(.gray, for: .normal)
        timerLabel.text = String(format: "00:00:00")
        shapeLayer.removeAnimation(forKey: "basicAnimation")
        animationCircular(strokeEnd: 1)
        timer.invalidate()
        trueIsHiddenButton()
        pickerView.isHidden = false
        startButton.isHidden = false
        currentStrokeEnd = 0.0
        durationTimer = 60
        modifiedTimer = 60
        pickerView.countDownDuration = 0
    }
    
    @objc func stopAlarmButtonTapped() {
        stopAlarmButton.isHidden = true
        cancelButton.isHidden = false
        startButton.isHidden = false
        player.stop()
    }
    
    @objc func pauseButtonTapped() {
        pauseButton.isHidden = true
        startButton.isHidden = true
        fartherButton.isHidden = false
        timer.invalidate()
        shapeLayer.removeAllAnimations()
        let number = Double(durationTimer) / Double(modifiedTimer)
        animationCircular(strokeEnd: CGFloat(number))
        currentStrokeEnd = number
        shapeLayer.speed = 0
    }
    
    @objc func fartherButtonTapped() {
        shapeLayer.speed = 1
        showBasicAnimation()
        startButton.isHidden = true
        fartherButton.isHidden = true
        pauseButton.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func startButtonTapped() {
        DispatchQueue.main.async {
            self.animationCircular(strokeEnd: 1)
            self.showBasicAnimation()
        }
        cancelButton.setTitleColor(.white, for: .normal)
        pauseButton.isHidden = false
        shapeView.isHidden = false
        timerLabel.isHidden = false
        startButton.isHidden = true
        pickerView.isHidden = true
        shapeLayer.speed = 1
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func timerAction() {
        durationTimer -= 1
        let hours = durationTimer / 3600
        let minutes = (durationTimer % 3600) / 60
        let seconds = (durationTimer % 3600) % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        if durationTimer == 0 {
            playSound()
            timer.invalidate()
            shapeLayer.removeAnimation(forKey: "basicAnimation")
            durationTimer = 60
            modifiedTimer = 60
            trueIsHiddenButton()
            startButton.isHidden = true
            cancelButton.isHidden = true
            pickerView.isHidden = false
            stopAlarmButton.isHidden = false
            pickerView.countDownDuration = 0
        }
    }
}
// MARK: - extension TimerViewController: setConstraints
private extension TimerViewController {
    func setConstraints() {
        view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            shapeView.heightAnchor.constraint(equalToConstant: 350),
            shapeView.widthAnchor.constraint(equalToConstant: 350),
            
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            pickerView.heightAnchor.constraint(equalToConstant: 150),
            pickerView.widthAnchor.constraint(equalToConstant: 250),
            
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.heightAnchor.constraint(equalToConstant: 80),
            startButton.widthAnchor.constraint(equalToConstant: 80),
            
            pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pauseButton.heightAnchor.constraint(equalToConstant: 80),
            pauseButton.widthAnchor.constraint(equalToConstant: 80),
            
            fartherButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            fartherButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            fartherButton.heightAnchor.constraint(equalToConstant: 80),
            fartherButton.widthAnchor.constraint(equalToConstant: 80),
            
            stopAlarmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            stopAlarmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stopAlarmButton.heightAnchor.constraint(equalToConstant: 80),
            stopAlarmButton.widthAnchor.constraint(equalToConstant: 80),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 80),
            cancelButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
private extension UIDatePicker {
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
}
