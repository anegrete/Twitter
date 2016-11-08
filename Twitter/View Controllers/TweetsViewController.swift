//
//  TweetsViewController.swift
//  Twitter
//
//  Created by anegrete on 11/7/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

	@IBOutlet var tweetsTableView: UITableView!

	var tweets:[Tweet]?

	var refreshControl = UIRefreshControl()
	var loadingMoreView:InfiniteScrollActivityView?
	var loading = false

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		retrieveTweets(maxId: nil)
		initTableView()
		initObservers()
		initRefreshControl()
		setupLoadingMoreView()
		customizeNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		customizeNavigationBar()
	}

	override var prefersStatusBarHidden: Bool {
		return false
	}

	// MARK: - Initializations

	func initTableView() {
		tweetsTableView.rowHeight = UITableViewAutomaticDimension
		tweetsTableView.estimatedRowHeight = 150
		tweetsTableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
	}

	func initObservers() {
		NotificationCenter.default.addObserver(
			forName: NSNotification.Name(rawValue: NotificationName.userDidTweet),
			object: nil,
			queue: OperationQueue.main) {
				(notification: Notification) in
				let newTweet = notification.userInfo?["tweet"] as! Tweet
				self.tweets?.insert(newTweet, at: 0)
				self.tweetsTableView.reloadData()
		}
	}

	func customizeNavigationBar() {
		UIHelper.blueNavigationBarFor(viewController: self)
	}

	// MARK: - Refresh Control

	func initRefreshControl() {

		refreshControl = UIRefreshControl()
		refreshControl.tintColor = Color.lightGray
		refreshControl.addTarget(self,
		                         action: #selector(refreshControlAction(refreshControl:)),
		                         for: UIControlEvents.valueChanged)
		tweetsTableView.insertSubview(refreshControl, at: 0)
	}

	func refreshControlAction(refreshControl: UIRefreshControl) {
		retrieveTweets(maxId: nil)
	}

	// MARK: - Infinite Scroll

	func setupLoadingMoreView() {

		let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
		loadingMoreView = InfiniteScrollActivityView(frame: frame)
		loadingMoreView!.isHidden = true
		tweetsTableView.addSubview(loadingMoreView!)

		var insets = tweetsTableView.contentInset;
		insets.bottom += InfiniteScrollActivityView.defaultHeight;
		tweetsTableView.contentInset = insets
	}

	// MARK: - Tweets

	func retrieveTweets(maxId: String?) {
		preconditionFailure("This method must be overriden")
	}

	func loadMoreData() {
		loading = true
		let max_id = tweets?.last?.id_str
		retrieveTweets(maxId: max_id!)
	}
}

// MARK: - UITableViewDataSource

extension TweetsViewController : UITableViewDataSource {

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tweets?.count ?? 0
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
		cell.tweet = tweets?[indexPath.row]
		cell.selectionStyle = UITableViewCellSelectionStyle.none
		return cell
	}
}

extension TweetsViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		UIStoryboard.showDetailViewControllerWith(tweet: (tweets?[indexPath.row])!)
	}
}

// MARK: - UIScrollViewDelegate

extension TweetsViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {

		if (!loading) {
			let scrollViewContentHeight = tweetsTableView.contentSize.height
			let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height

			let isScrollingDown = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0

			if(scrollView.contentOffset.y > scrollOffsetThreshold
				&& tweetsTableView.isDragging
				&& !isScrollingDown) {

				loading = true

				let frame = CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
				loadingMoreView?.frame = frame
				loadingMoreView!.startAnimating()
				
				loadMoreData()
			}
		}
	}
}
