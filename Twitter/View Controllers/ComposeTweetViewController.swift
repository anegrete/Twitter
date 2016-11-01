//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit
import MBProgressHUD

class ComposeTweetViewController: UIViewController {

	@IBOutlet weak var tweetLimitLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var tweetTextView: UITextView!
	@IBOutlet weak var tweetButton: UIButton!

	var replyToTweet:Tweet?

	// MARK: - View Lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()

		setupProfileImage()
		setupTextView()
    }

	// MARK: - UI Updates

	func setupProfileImage() {
		profileImageView.layer.cornerRadius = 3
		profileImageView.clipsToBounds = true
		profileImageView.setImageWith((User.currentUser?.profileUrl)!)
	}

	func setupTextView() {

		let draft = UserDefaultsManager.draft()
		if draft != nil {
			enableTweetButton(enable: true)
			tweetTextView.text = draft
			tweetTextView.textColor = Color.black
		}
		else {
			enableTweetButton(enable: false)
			tweetTextView.text = "What's happening?"
			tweetTextView.textColor = Color.lightGray
		}

		if let replyToTweet = replyToTweet {
			let defaultText = "@" + (replyToTweet.user?.screenname)! + " "
			tweetTextView.text = defaultText
			tweetTextView.textColor = Color.black
		}
	}

	func enableTweetButton(enable: Bool) {
		tweetButton.isEnabled = enable
		tweetButton.alpha = tweetButton.isEnabled ? 1 : 0.4
	}

	// MARK: - UI Actions

	@IBAction func didTapTweetButton(_ sender: UIButton) {

		if let replyToTweet = replyToTweet {

			TwitterClient.shared?.reply(
				tweet: replyToTweet,
				text: tweetTextView.text!,
				success: { (tweet: Tweet) in

				},
				failure: { (error: Error) in
					UIHelper.showError(message: "Can't reply tweet right now. Please try again later")
				}
			)
		}
		else {
			TwitterClient.shared?.compose(
				text: tweetTextView.text!,
				success: { (tweet: Tweet) in

				},
				failure: { (error: Error) in
					UIHelper.showError(message: "Can't tweet right now. Please try again later")
				}
			)
		}

		UserDefaultsManager.saveDraft(draft: nil)
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func didTapCancelButton(_ sender: AnyObject) {

		if (tweetTextView.text.characters.count == 0) {
			self.dismiss(animated: true, completion: nil)
		}

		showAlertAction()
	}

	func showAlertAction() {

		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction)
			in
			UserDefaultsManager.saveDraft(draft: nil)

			self.dismiss(animated: true, completion: nil)
		}

		let saveDraftAction = UIAlertAction(title: "Save draft", style: .default) { (UIAlertAction) in
			UserDefaultsManager.saveDraft(draft: self.tweetTextView.text!)

			let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud.customView = UIImageView(image: UIImage(named: "Checkmark.png"))
			hud.mode = .customView
			hud.label.text = "Draft saved!"
			hud.isUserInteractionEnabled = false
			hud.hide(animated: true, afterDelay: 2)

			self.perform(#selector(self.dismiss(animated:completion:)), with: nil, afterDelay: 2)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(deleteAction)
		alertController.addAction(saveDraftAction)
		alertController.addAction(cancelAction)

		present(alertController, animated: true, completion: nil)
	}
}

// MARK: - UITextViewDelegate

extension ComposeTweetViewController : UITextViewDelegate {

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

		let tweet = tweetTextView.text!

		enableTweetButton(enable: text.characters.count > 0)

		let limit = 140 - tweet.characters.count
		tweetLimitLabel.text = String(limit)

		return limit <= 0 ? false : true
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == Color.lightGray {
			textView.text = UserDefaultsManager.draft() ?? nil
			textView.textColor = Color.black
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "What's happening?"
			textView.textColor = Color.lightGray
			enableTweetButton(enable: false)
		}
	}
}
