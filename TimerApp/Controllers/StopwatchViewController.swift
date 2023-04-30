//
//  StopwatchViewController.swift
//  TimerApp
//
//  Created by Денис Набиуллин on 19.04.2023.
//

import UIKit

final class StopwatchViewController: UIViewController {
    private var timer = Timer()
    private var currentStrokeEnd: CGFloat = 0.0
    private var stopwatch = 0.0
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let startButton: CustomButton = {
        let button = CustomButton(title: "Start", titleColor: .green, backColor: .systemGreen)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: CustomButton = {
        let button = CustomButton(title: "Reset", titleColor: .gray, backColor: .darkGray)
        button.addTarget(self, action: #selector(resetlButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stopButton: CustomButton = {
        let button = CustomButton(title: "Pause", titleColor: .white, backColor: .systemRed)
        button.isHidden = true
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(resetButton)
    }
}
// MARK: - extension StopwatchViewController: @objc
private extension StopwatchViewController {
    @objc func resetlButtonTapped() {
        timer.invalidate()
        resetButton.setTitleColor(.gray, for: .normal)
        timerLabel.text = String(format: "00:00:00")
        stopwatch = 0.0
        stopButton.isHidden = true
        startButton.isHidden = false
    }
    
    @objc func stopButtonTapped() {
        stopButton.isHidden = true
        startButton.isHidden = false
        timer.invalidate()
    }
    
    @objc func startButtonTapped() {
        startButton.isHidden = true
        stopButton.isHidden = false
        resetButton.isHidden = false
        resetButton.setTitleColor(.white, for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func timerAction() {
        stopwatch += 0.1
        let flooredCounter = Int(floor(stopwatch))
        let minutes = (flooredCounter % 3600) / 60
        let seconds = (flooredCounter % 3600) % 60
        let millisecond = Int((stopwatch.truncatingRemainder(dividingBy: 1)) * 99.0)
        let leadingZeroMin = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let leadingZeroSec = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let leadingZeroMil = millisecond > 9 ? "\(millisecond)" : "0\(millisecond)"
        timerLabel.text = "\(leadingZeroMin):\(leadingZeroSec).\(leadingZeroMil)"
        if Int(stopwatch) == 3540 {
            resetButton.setTitleColor(.gray, for: .normal)
            stopButton.isHidden = true
            startButton.isHidden = false
            timer.invalidate()
            stopwatch = 0.0
            timerLabel.text = "00:00:00"
        }
    }
}
// MARK: - extension StopwatchViewController: setConstraints
private extension StopwatchViewController {
    func setConstraints() {
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            timerLabel.heightAnchor.constraint(equalToConstant: 150),
            timerLabel.widthAnchor.constraint(equalToConstant: 250),
            
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.heightAnchor.constraint(equalToConstant: 80),
            startButton.widthAnchor.constraint(equalToConstant: 80),
            
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stopButton.heightAnchor.constraint(equalToConstant: 80),
            stopButton.widthAnchor.constraint(equalToConstant: 80),
            
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            resetButton.heightAnchor.constraint(equalToConstant: 80),
            resetButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
