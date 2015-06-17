//
//  ViewController.swift
//  SwiftExample
//
//  Created by Nick Lockwood on 30/07/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,  iCarouselDelegate
{

    var moviePlayer : MPMoviePlayerController?
    var items: [Int] = []
    @IBOutlet var carousel : iCarousel!
    
  @IBOutlet weak var videoContainer: UIView!
  
  @IBOutlet weak var btnAddPerson: UIBarButtonItem!
  
    override func awakeFromNib()
    {
        super.awakeFromNib()
        for i in 0...5
        {
            items.append(i)
        }
    }
  
  
  func playVideo() ->Bool {
    
    let path = NSBundle.mainBundle().pathForResource("video", ofType:"mp4")
    //take path of video
    
    let url = NSURL.fileURLWithPath(path!)
    
    moviePlayer = MPMoviePlayerController(contentURL: url)
    //asigning video to moviePlayer
    
    if let player = moviePlayer {
      player.view.frame = self.view.bounds
      //setting the video size to the view size
      
      player.controlStyle = MPMovieControlStyle.None
      //Hiding the Player controls
      
      
      player.prepareToPlay()
      //Playing the video
      
      
      player.repeatMode = .One
      //Repeating the video
      
      player.scalingMode = .AspectFill
      //setting the aspect ratio of the player
      
      self.videoContainer.addSubview(player.view)
      //adding the player view to viewcontroller
      return true
      
    }
    return false
  }
  
    
  override func viewDidLoad()
  {
    super.viewDidLoad()
    playVideo()
    moviePlayer?.repeatMode = .One
    carousel.type = .Rotary
    
    var refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh
      , target: self
      , action: "refreshMethod")
    
    var trashButton = UIBarButtonItem(barButtonSystemItem: .Trash
      , target: self
      , action: "trashMethod")
    
    var buttonsArray = [refreshButton, trashButton]
    
    self.navigationItem.setLeftBarButtonItems(buttonsArray, animated: true)
    
    
  }
  
  func refreshMethod() {
    
    for item in self.items{
      self.items.removeAtIndex(0)
      self.carousel.removeItemAtIndex(0, animated: true)
    }
    
    
  }
  
  func trashMethod() {
    
    if self.carousel.numberOfItems > 0 {
      var index = self.carousel.currentItemIndex
      self.carousel.removeItemAtIndex(index, animated: true)
      self.items.removeAtIndex(index)
    }
    
  }
    
  func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
  {
    //return items.count
    
    return self.carousel.numberOfItems
  }
  
  @objc func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView!
  {
    var label: UILabel! = nil
    var newView = view
    //create new view if no view is available for recycling
    if (newView == nil)
    {
      //don't do anything specific to the index within
      //this `if (view == nil) {...}` statement because the view will be
      //recycled and used with other index values later
      newView = UIImageView(frame:CGRectMake(0, 0, 200, 200))
      
      (newView as! UIImageView!).image = UIImage(named: "page.png")
      newView.contentMode = .Center
      
      label = UILabel(frame:newView.bounds)
      label.backgroundColor = UIColor.clearColor()
      label.textAlignment = .Center
      label.font = label.font.fontWithSize(50)
      label.tag = 1
      newView.addSubview(label)
      //            self.carousel.addSubview(newView)
    }
    else
    {
      //get a reference to the label in the recycled view
      label = newView.viewWithTag(1) as! UILabel!
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = "\(items[index])"
    
    return newView
  }
  
  func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
  {
    if (option == .Spacing)
    {
      return value * 1.1
    }
    return value
  }
  
  @IBAction func addPerson(sender: AnyObject) {
    
    var index: Int = max(0, self.carousel.currentItemIndex)
    self.items.insert(self.carousel.numberOfItems, atIndex: index)
    self.carousel.insertItemAtIndex(index, animated: true)
    
  }
  

}

