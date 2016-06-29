//
//  ViewController.swift
//  Swipe Control HD
//
//  Created by Ryan Morris on 2016-06-17.
//  Copyright © 2016 Ryan Morris. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    @IBOutlet var swipeDown: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    @IBOutlet var swipeRight: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeft2: UISwipeGestureRecognizer!
    @IBOutlet var swipeRight2: UISwipeGestureRecognizer!
    
    @IBOutlet weak var swipeLabel: UILabel!

    var musicPlayer:MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer()
    var currentPlayingSong = MPMediaItem()
    // PlayLists - Array
    var playLists = NSArray()
    var playlistID = NSString()
    
    var isPlay = false;
    
    //variables from settings
    var toggleSwipe = true
    var toggleShuffle = true
    var toggleRepeat = true
    
    @IBOutlet weak var openMessage: UITextField!
    @IBOutlet weak var backgroundType: UISegmentedControl!
    @IBOutlet weak var btnHelpIcon: UIButton!
    
    var background:  Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //settings methods
        registerSettingsBundle()
        updateDisplayFromDefaults()
        696946
      /*  NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: Selector("defaultsChanged"),
                                                         name: NSUserDefaultsDidChangeNotification,
                                                         object: nil)
        */
       let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapDetected(_:)))
       view.addGestureRecognizer(doubleTap)
        
        //let pinchDetected = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinchDetected(_:)))
        //view.addGestureRecognizer(pinchDetected)

        let longPressDetected = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressDetected(_:)))
        view.addGestureRecognizer(longPressDetected)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ViewController.handlePlayingItemChanged), name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: musicPlayer)
        notificationCenter.addObserver(self, selector: #selector(ViewController.handlePlayState), name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: musicPlayer)
        musicPlayer.beginGeneratingPlaybackNotifications()
        
        if (musicPlayer.playbackState == MPMusicPlaybackState.Playing) {
           // swipeLabel.text = "Playing"
            self.isPlay = true
        }
    }
    
    @IBAction func btnHelpIcon(sender: AnyObject) {
        let alertController = UIAlertController(title: "Swipe Instructions", message:
            "Right: Next Song \n Left: Previous Song \n Up: Shuffle Mode \n Down: Repeat Mode \n Hold: Restart Song", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }

    
    @IBAction func rightGesture(sender: UISwipeGestureRecognizer) {
        musicPlayer.skipToNextItem()
        swipeLabel.text =  "Next"
        changeBG()
    }
    @IBAction func leftGesture(sender: UISwipeGestureRecognizer) {
        musicPlayer.skipToPreviousItem()
        swipeLabel.text =  "Back"
        changeBG()
    }
    @IBAction func upGesture(sender: UISwipeGestureRecognizer) {
         if(toggleShuffle == true)
         {
        if musicPlayer.shuffleMode == MPMusicShuffleMode.Off {
            musicPlayer.shuffleMode = MPMusicShuffleMode.Songs
            swipeLabel.text =  "Shuffle"
        } else {
            musicPlayer.shuffleMode = MPMusicShuffleMode.Off
           swipeLabel.text = "Normal"
        }
        }
    }
    
    @IBAction func downGesture(sender: UISwipeGestureRecognizer) {
    if(toggleRepeat == true)
    {
        if (musicPlayer.repeatMode == MPMusicRepeatMode.One) {
            musicPlayer.repeatMode = MPMusicRepeatMode.All
            swipeLabel.text = "Repeat All"
        } else if (musicPlayer.repeatMode == MPMusicRepeatMode.All) {
            musicPlayer.repeatMode = MPMusicRepeatMode.None
            swipeLabel.text = "Repeat Off"
        } else {
            musicPlayer.repeatMode = MPMusicRepeatMode.One
            swipeLabel.text = "Repeat Song"
        }
    }

    }
    
    @IBAction func tapDetected(sender: UITapGestureRecognizer) {
        if (self.isPlay) {
            musicPlayer.pause()
            self.isPlay = false
             swipeLabel.text = "Paused"
        } else {
            musicPlayer.play()
            self.isPlay = true
             swipeLabel.text = "Play"
        }
    }
    func addTime(adjust: Double = 1, plus : Bool = true)  {
       //  swipeLabel.text = "Paused"
      do {
        if (self.isPlay) {
            if plus
            {
                musicPlayer.currentPlaybackTime = musicPlayer.currentPlaybackTime + adjust
               // swipeLabel.text = "Forward " + String (adjust)
            }
            else
            {
                musicPlayer.currentPlaybackTime = musicPlayer.currentPlaybackTime - adjust
            }
        }
        }
        //swipeLabel.text =  String (adjust)

    }
    
    @IBAction func rightGesture2(sender: UISwipeGestureRecognizer) {
        addTime(30,plus: true)
        swipeLabel.text = "FF 30"
    }
    @IBAction func leftGesture2(sender: UISwipeGestureRecognizer) {
      addTime(30, plus: false)
        swipeLabel.text = "RW 30"
    }
    
    @IBAction func rightGesture3(sender: UISwipeGestureRecognizer) {
        addTime(60,plus: true)
        swipeLabel.text = "FF 60"
    }
    @IBAction func leftGesture3(sender: UISwipeGestureRecognizer) {
        addTime(60, plus: false)
        swipeLabel.text = "RW 60"
    }
    
    @IBAction func rightGesture4(sender: UISwipeGestureRecognizer) {
         addTime(300,plus: true)
        swipeLabel.text = "FF 300"
    }
    @IBAction func leftGesture4(sender: UISwipeGestureRecognizer) {
        addTime(300, plus: false)
        swipeLabel.text = "RW 300"
    }

   /*
    @IBAction func pinchDetected(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let velocity = sender.velocity
        let resultString =
            "Pinch - scale = \(scale), velocity = \(velocity)"
           print(resultString)
    }
    */
   @IBAction func longPressDetected(sender: UILongPressGestureRecognizer) {
    swipeLabel.text = "Reset"
    print("Long Press")
     //   changeBG()
     musicPlayer.skipToBeginning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //stackoverflow.com/questions/24112272/uiview-background-color-in-swift
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    func rngHexColor()->UInt32{
    //let  r = (arc4random_uniform(254) + 1)
    //let g = (arc4random_uniform(254) + 1)
    //let b = (arc4random_uniform(254) + 1)
   // let rng = (arc4random_uniform(42949000) + 1)
        let rng = (arc4random_uniform(23949000) + 1000)
        //let rng = (arc4random_uniform(31949000) + 1000)
        //let res  =  "#" + String(r) + String(g) + String(b)
   // let z = r + g + b;
    let res = UInt32( rng)
    return res;
    }
    
    func changeBG(){
        self.view.backgroundColor = UIColorFromHex(rngHexColor())
    }
    
    func changePlaylist(playlistID: String, playlists: NSMutableArray) {
        
        self.playlistID = playlistID
        self.playLists = playlists
        
        if (playLists.count > 0) {
            for playList in playLists {
                
                let playlistID =  "\(playList.valueForProperty(MPMediaPlaylistPropertyPersistentID))"
                
                if playlistID == self.playlistID {
                    let collection = MPMediaItemCollection(items: playList.items)
                    musicPlayer.setQueueWithItemCollection(collection)
                }
                
                musicPlayer.play()
            }
        }
    }
    
    func handlePlayingItemChanged() {
      //  setupCurrentMediaItem()
    }
    
    func handlePlayState() {
        if (musicPlayer.playbackState == MPMusicPlaybackState.Paused) {
            swipeLabel.text = "Paused"
            self.isPlay = false
        } else if (self.isPlay == true || musicPlayer.playbackState == MPMusicPlaybackState.Playing) {
            swipeLabel.text = "Play"
                self.isPlay = true
        } else {
            swipeLabel.text = "Paused"
                self.isPlay = false
        }
        
    }
    
    //settings
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
    }
    
    func updateDisplayFromDefaults(){
        //Get the defaults
        let appDefault = Dictionary<String, AnyObject>()
        let defaults = NSUserDefaults.standardUserDefaults()
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefault)
        NSUserDefaults.standardUserDefaults().synchronize()
        

        
        if NSUserDefaults.standardUserDefaults().objectForKey("toggle_Skip") != nil
        {
            let x  = NSUserDefaults.standardUserDefaults().boolForKey("toggle_Skip")
            if x{
                toggleSwipe = true

            }
            else {
                toggleSwipe = false

            }
            
        }
        else{
            toggleSwipe = true
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("toggle_Shuffle")  != nil
        {
            let x  = NSUserDefaults.standardUserDefaults().boolForKey("toggle_Shuffle")
            if x{
                toggleShuffle = true
            }
            else {
                toggleShuffle = false
            }
        }
        else{
            toggleShuffle = true
        }
        if  NSUserDefaults.standardUserDefaults().objectForKey("toggle_Repeat") != nil
        {
            let x  = NSUserDefaults.standardUserDefaults().boolForKey("toggle_Repeat")
            if x{
                toggleRepeat = true
            }
            else {
                toggleRepeat = false
            }
        }
        else{
            toggleRepeat = true
        }
        if let label_text = NSUserDefaults.standardUserDefaults().stringForKey("message_swipe"){
            swipeLabel.text = label_text
        } else{
            swipeLabel.text = ""
            defaults.setValue("", forKey: "message_swipe")

        }
        if let _ : Int = NSUserDefaults.standardUserDefaults().integerForKey("background_type")
        {
          //  background = NSUserDefaults.standardUserDefaults().integerForKey("background_type")
        }
        else
        {
            // defaults.setValue("0", forKey: "background_type")
        }
    }

    deinit { //Not needed for iOS9 and above. ARC deals with the observer.
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

