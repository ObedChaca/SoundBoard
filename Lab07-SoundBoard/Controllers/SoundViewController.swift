import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var inputname: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addbutton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputname.layer.cornerRadius=8.0
        inputname.layer.masksToBounds=true
        inputname.layer.borderColor = UIColor.red.cgColor
        inputname.layer.borderWidth = 1.0
        
        
        self.hideKeyBoard()
        setUpRecord()
        playButton.isEnabled = false
        addbutton.isEnabled = false
        playButton.setTitle("Disabled", for: .normal)
        playButton.backgroundColor = .red
        
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = .black
            playButton.setTitleColor(.white, for: .normal)
            addbutton.isEnabled = true
        }else{
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        }catch let error as NSError{
            print(error)
        }
    }
    
    @IBAction func addTaped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = inputname.text
        sound.audio = NSData(contentsOf: audioURL!) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
    func setUpRecord(){
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first!
            let pathComponeths = [basePath, "audio.m4a"]
            
            audioURL = NSURL.fileURL(withPathComponents: pathComponeths)
            
            print("......................")
            print(audioURL)
            print("......................")
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.prepareToRecord()
            
        } catch let error as NSError{
            print(error)
        }
    }
    
    
}
