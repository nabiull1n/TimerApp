//
//  TabBarController.swift
//  TimerApp
//
//  Created by Денис Набиуллин on 19.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
        if UIScreen.main.bounds.size.height > 736 {
            setTabBarAppearance()
            setupForRoundedTabBar()
        } else {
            setupTabBar()
        }
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .darkGray
    }
    
    private func setupForRoundedTabBar() {
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func createTabBar() {
        setViewControllers([
            createVC(viewController: TimerViewController(),
                     title: "Timer",
                     image: UIImage(systemName: "timer")),
            createVC(viewController: StopwatchViewController(),
                     title: "Stopwatch",
                     image: UIImage(systemName: "stopwatch"))
        ] , animated: false)
    }
    
    private func createVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance(){
        let positionX: CGFloat = 10
        let positionY: CGFloat = 14
        let width = tabBar.bounds.width - positionX * 2
        let height = tabBar.bounds.height + positionY * 2
        let circularLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionX,
                                                          y: tabBar.bounds.minY - positionY,
                                                          width: width,
                                                          height: height), cornerRadius: height / 2)
        circularLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(circularLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .automatic
        circularLayer.fillColor = UIColor.darkGray.cgColor
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item),
              tabBar.subviews.count > idx + 1,
              let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
