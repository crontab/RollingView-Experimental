//
//  MainViewController.swift
//  Messenger
//
//  Created by Hovik Melikyan on 05/06/2019.
//  Copyright © 2019 Hovik Melikyan. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, RollingViewDelegate {

	@IBOutlet weak var rollingView: RollingView!

	@IBOutlet weak var bottomBar: UIView!


	private var factories: [TextBubbleFactory.Side: TextBubbleFactory]!

	private var lines = try! String(contentsOfFile: Bundle.main.path(forResource: "Bukowski", ofType: "txt")!, encoding: .utf8).components(separatedBy: .newlines).filter { !$0.isEmpty }


	override func viewDidLoad() {
		super.viewDidLoad()

		rollingView.alwaysBounceVertical = true
		// rollingView.showsVerticalScrollIndicator = false
		rollingView.rollingViewDelegate = self

		let leftFactory = TextBubbleFactory()
		leftFactory.font = UIFont.systemFont(ofSize: 17, weight: .regular)
		leftFactory.textColor = UIColor.white
		leftFactory.margins.right = 100

		let rightFactory = TextBubbleFactory()
		rightFactory.font = leftFactory.font
		rightFactory.textColor = UIColor.black
		rightFactory.bubbleSide = .right
		rightFactory.margins.left = leftFactory.margins.right
		rightFactory.bubbleColor = UIColor(red: 231 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1)

		factories = [.left: leftFactory, .right: rightFactory]
	}


	private var firstLayout = true

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if firstLayout {
			firstLayout = false
			rollingView.bottomInset = bottomBar.frame.height
		}
	}


	@IBAction func addAction(_ sender: UIButton) {
		let edge = RollingView.Edge(rawValue: sender.tag)!
		rollingView.addCells(edge, count: 1)
	}


	private var side: TextBubbleFactory.Side = .right

	func rollingView(_ rollingView: RollingView, cellLayerForIndex index: Int) -> CALayer {
		return self.rollingView(rollingView, updateCellLayer: nil, forIndex: index)
	}


	func rollingView(_ rollingView: RollingView, updateCellLayer layer: CALayer?, forIndex index: Int) -> CALayer {
		side = side == .left ? .right : .left
		let string = lines[abs(index) % lines.count]
		return factories[side]!.create(width: view.frame.width, string: string)
	}


	private var kbShown = false

	@IBAction func insetAction(_ sender: Any) {
		kbShown = !kbShown
		UIView.animate(withDuration: 0.25) {
			self.rollingView.bottomInset = self.bottomBar.frame.height + (self.kbShown ? 300 : 0)
		}
	}
}
