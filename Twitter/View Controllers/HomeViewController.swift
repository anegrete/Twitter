//
//  HomeViewController.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class HomeViewController: TweetsViewController {

	// MARK: - Tweets

	override func retrieveTweets(maxId: String) {
		TwitterClient.shared?.homeTimeline(
			maxId: maxId,
			success: { (newTweets: [Tweet]) in
				if maxId != "" {
					self.loading = false
					self.loadingMoreView!.stopAnimating()
					self.tweets?.append(contentsOf: newTweets)
				}
				else {
					self.refreshControl.endRefreshing()
					self.tweets = newTweets
				}

				self.tweetsTableView.reloadData()
			},
			failure: { (error: Error) in
				UIHelper.showError(message: "Can't get tweets right now. Please try again later")
				self.refreshControl.endRefreshing()
		})
	}
}
