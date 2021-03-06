import Foundation


@objc public class NoteBlockUserTableViewCell : NoteBlockTableViewCell
{
    public typealias EventHandler = (() -> Void)
    
    // MARK: - Public Properties
    public var onFollowClick:      EventHandler?
    public var onUnfollowClick:    EventHandler?
    
    public var isFollowEnabled: Bool = false {
        didSet {
            btnFollow.hidden  = !isFollowEnabled
        }
    }
    public var isFollowOn: Bool = false {
        didSet {
            btnFollow.selected = isFollowOn
        }
    }
    
    public var name: String? {
        didSet {
            nameLabel.text  = name ?? String()
        }
    }
    public var blogTitle: String? {
        didSet {
            blogLabel.text  = blogTitle ?? String()
        }
    }
    
    // MARK: - Public Methods
    public func downloadGravatarWithURL(url: NSURL?) {
        if url == gravatarURL {
            return
        }
    
        let success = { (image: UIImage) in
            self.gravatarImageView.displayImageWithFadeInAnimation(image)
        }
        
        gravatarImageView.downloadImage(url, placeholderName: placeholderName, success: success, failure: nil)
        
        gravatarURL = url
    }
    
    // MARK: - View Methods
    public override func awakeFromNib() {
        super.awakeFromNib()

        WPStyleGuide.configureFollowButton(btnFollow)
        btnFollow.titleLabel?.font          = WPStyleGuide.Notifications.blockRegularFont

        backgroundColor                     = WPStyleGuide.Notifications.blockBackgroundColor
        accessoryType                       = .None
        contentView.autoresizingMask        = .FlexibleHeight | .FlexibleWidth
        
        nameLabel.font                      = WPStyleGuide.Notifications.blockBoldFont
        nameLabel.textColor                 = WPStyleGuide.Notifications.blockTextColor
        
        blogLabel.font                      = WPStyleGuide.Notifications.blockRegularFont
        blogLabel.textColor                 = WPStyleGuide.Notifications.blockSubtitleColor
        blogLabel.adjustsFontSizeToFitWidth = false;
        
        // iPad: Use a bigger image size!
        if UIDevice.isPad() {
            gravatarImageView.updateConstraint(.Height, constant: gravatarImageSizePad.width)
            gravatarImageView.updateConstraint(.Width,  constant: gravatarImageSizePad.height)
        }
    }
    
    // MARK: - IBActions
    @IBAction public func followWasPressed(sender: AnyObject) {
        if let listener = isFollowOn ? onUnfollowClick : onFollowClick {
            listener()
        }
        isFollowOn = !isFollowOn
    }
    
    // MARK: - Private
    private let gravatarImageSizePad                = CGSize(width: 54.0, height: 54.0)
    private let placeholderName                     = String("gravatar")
    private var gravatarURL:                        NSURL?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel:           UILabel!
    @IBOutlet private weak var blogLabel:           UILabel!
    @IBOutlet private weak var btnFollow:           UIButton!
    @IBOutlet private weak var gravatarImageView:   CircularImageView!
}
