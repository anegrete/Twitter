# Project 4 - Twitter

Time spent: 10 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
	- [x] Dragging anywhere in the view should reveal the menu.
	- [x] The menu should include links to your profile, the home timeline, and the mentions view.
	- [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
	- [x] Contains the user header view
	- [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
	- [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] Profile Page (old version of the Twitter app)
	- [ ] Implement the paging view for the user description.
	- [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
	- [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
	- [ ] Long press on tab bar to bring up Account view with animation
	- [ ] Tap account to switch to
	- [ ] Include a plus button to Add an Account
	- [ ] Swipe to delete an account

The following **additional** features are implemented:

- [x] Profile Page (new version of the Twitter app)
	- [x] Parallax effect with user profile background image like in actual Twitter app
- [x] Hamburger menu
	- [x] Tap gesture to open and close menu from every view controller
	- [x] Logout added as a menu option
- [x] Code
	- [x] Separate functionality in different Storyboards
	- [x] Implement generic View Controller for screens that display table views with tweets (home, user and mentions timelines)

- [x] Tweets
	- [x] Detect links automatically and open urls when clicked, in tweet cells and tweet detail

##########

# Project 3 - Twitter

Twitter is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: 18 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] Save draft and show the last saved draft when composing a new tweet.
- [x] Show alert action to save draft when composing a tweet.
- [x] Detect when no internet connection and display a message.
- [x] Navigation bar, icons, status bar customized with similar Twitter blue style.

##########

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Best way to reuse components in differents view controllers
2. Best way to use extensions


## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](Twitter-anegrete-4.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Icons by http://iconmonstr.com/

Used libraries (using CocoaPods):

- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
A delightful networking framework for iOS, OS X, watchOS, and tvOS. 

- [MBProgressHUD](https://github.com/matej/MBProgressHUD)
MBProgressHUD, an iOS activity indicator view

- [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
OAuth 1.0a library for AFNetworking 2.x

- [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)
A drop-in replacement for UILabel that supports attributes, data detectors, links, and more

## License

Copyright 2016 Alejandra Negrete

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
