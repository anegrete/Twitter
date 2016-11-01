//
//  HomeViewController.swift
//  Twitter
//
//  Created by anegrete on 10/29/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	@IBOutlet var tweetsTableView: UITableView!

	var tweets:[Tweet]?

	var refreshControl = UIRefreshControl()
	var loadingMoreView:InfiniteScrollActivityView?
	var loading = false

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		homeTimeline()
		initTableView()
		initObservers()
		initRefreshControl()
		setupLoadingMoreView()
		customizeNavigationBar()
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
		let logo = UIImage(named: "Twitter-icon-white.png")
		let imageView = UIImageView(image:logo)
		self.navigationItem.titleView = imageView
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
		self.navigationController?.navigationBar.tintColor = UIColor.white
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
		homeTimeline()
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

	// MARK: - UI Actions

	@IBAction func didTapLogout(_ sender: UIBarButtonItem) {
		TwitterClient.shared?.logout()
	}

	// MARK: - Tweets

	func homeTimeline() {
		TwitterClient.shared?.homeTimeline(
			success: { (tweets: [Tweet]) in
				self.refreshControl.endRefreshing()
				self.tweets = tweets
				self.tweetsTableView.reloadData()
			},
			failure: { (error: Error) in
				print("Error getting timeline")
				self.refreshControl.endRefreshing()
		})
	}

	func loadMoreData() {
		loading = true

		let max_id = tweets?.last?.id_str
		TwitterClient.shared?.moreTimeline(
			maxId: max_id!,
			success: { (tweets: [Tweet]) in
				self.loading = false
				self.loadingMoreView!.stopAnimating()
				self.tweets?.append(contentsOf: tweets)
				self.tweetsTableView.reloadData()
			},
			failure: { (error: Error) in
				print("Error getting timeline")
		})
	}
}

// MARK: - UITableViewDataSource

extension HomeViewController : UITableViewDataSource {

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

extension HomeViewController : UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let detailViewController = storyboard.instantiateViewController(withIdentifier: "TweetDetailViewController") as! TweetDetailViewController
		detailViewController.tweet = tweets?[indexPath.row]
		show(detailViewController, sender: nil)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {

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
