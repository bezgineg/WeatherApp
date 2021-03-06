import UIKit

@IBDesignable
public class CustomSwitch: UIControl {
    
    // MARK: Public properties
    
    @IBInspectable public var isOn:Bool = true
    
    public var animationDuration: Double = 0.5
    
    @IBInspectable public var padding: CGFloat = 1 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var onTintColor: UIColor = Colors.customSwitchOnTintColor {
        didSet {
            self.setupUI()
            
        }
    }
    
    @IBInspectable public var offTintColor: UIColor = Colors.customSwitchBlackColor {
        didSet {
            self.setupUI()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.privateCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateCornerRadius = 0.5
            } else {
                privateCornerRadius = newValue
            }
        }
        
    }
    
    private var privateCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutIfNeeded()
            
        }
    }
    
    // thumb properties
    @IBInspectable public var thumbTintColor: UIColor = Colors.customSwitchBlueColor {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    
    @IBInspectable public var thumbCornerRadius: CGFloat {
        get {
            return self.privateThumbCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateThumbCornerRadius = 0.5
            } else {
                privateThumbCornerRadius = newValue
            }
        }
        
    }
    
    private var privateThumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutIfNeeded()
            
        }
    }
    
    @IBInspectable public var thumbSize: CGSize = CGSize.zero {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var thumbImage:UIImage? = nil {
        didSet {
            guard let image = thumbImage else {
                return
            }
            thumbView.thumbImageView.image = image
        }
    }
    
    public var onImage:UIImage? {
        didSet {
            self.onImageView.image = onImage
            self.layoutIfNeeded()
            
        }
        
    }
    
    public var offImage:UIImage? {
        didSet {
            self.offImageView.image = offImage
            self.layoutIfNeeded()
            
        }
        
    }
    
    // dodati kasnije
    @IBInspectable public var thumbShadowColor: UIColor = Colors.customSwitchBlackColor {
        didSet {
            self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
        }
    }
    
    @IBInspectable public var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2) {
        didSet {
            self.thumbView.layer.shadowOffset = self.thumbShadowOffset
        }
    }
    
    @IBInspectable public var thumbShaddowRadius: CGFloat = 1.5 {
        didSet {
            self.thumbView.layer.shadowRadius = self.thumbShaddowRadius
        }
    }
    
    @IBInspectable public var thumbShaddowOppacity: Float = 0.4 {
        didSet {
            self.thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
        }
    }
    
    // labels
    
    public var labelOn:UILabel = UILabel()
    public var labelOff:UILabel = UILabel()
    
    public var areLabelsShown: Bool = false {
        didSet {
            self.setupUI()
        }
    }
    
    // MARK: Private properties
    fileprivate var thumbView = CustomThumbView(frame: CGRect.zero)
    fileprivate var onImageView = UIImageView(frame: CGRect.zero)
    fileprivate var offImageView = UIImageView(frame: CGRect.zero)
    
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
}

// MARK: Private methods
extension CustomSwitch {
    
    fileprivate func setupUI() {
        
        // clear self before configuration
        self.clear()
        
        self.clipsToBounds = false
        
        // configure thumb view
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        
        // dodati kasnije
        self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
        self.thumbView.layer.shadowRadius = self.thumbShaddowRadius
        self.thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
        self.thumbView.layer.shadowOffset = self.thumbShadowOffset
        
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        
        self.addSubview(self.thumbView)
        self.addSubview(self.onImageView)
        self.addSubview(self.offImageView)
        
        self.setupLabels()
        
    }
    
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        self.animate()
        return true
    }
    
    func setOn(on:Bool, animated:Bool) {
        
        switch animated {
        case true:
            self.animate(on: on)
        case false:
            self.isOn = on
            self.setupViewsOnAction()
            self.completeAction()
        }
        
    }
    
    fileprivate func animate(on:Bool? = nil) {
        
        self.isOn = on ?? !self.isOn
        
        self.isAnimating = true
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction], animations: {
            self.setupViewsOnAction()
            
        }, completion: { _ in
            self.completeAction()
            
        })
    }
    
    private func setupViewsOnAction() {
        self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        self.labelOn.textColor = self.isOn ? Colors.customSwitchWhiteColor : Colors.customSwitchBlackColor
        self.labelOff.textColor = self.isOn ? Colors.customSwitchBlackColor : Colors.customSwitchWhiteColor
        self.setOnOffImageFrame()
        
    }
    
    private func completeAction() {
        self.isAnimating = false
        self.sendActions(for: UIControl.Event.valueChanged)
        
    }
    
}

// Mark: Public methods
extension CustomSwitch {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            // thumb managment
            // get thumb size, if none set, use one from bounds
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width: self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            
            //label frame
            if self.areLabelsShown {
                
                let labelWidth = self.bounds.width / 2 - self.padding * 2
                self.labelOff.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
                self.labelOn.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
                
            }
            
            // on/off images
            //set to preserve aspect ratio of image in thumbView
            
            guard onImage != nil && offImage != nil else {
                return
            }
            
            let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.7 : thumbSize.width * 0.7
            
            let onOffImageSize = CGSize(width: frameSize, height: frameSize)
            
            
            self.onImageView.frame.size = onOffImageSize
            self.offImageView.frame.size = onOffImageSize
            
            self.onImageView.center = CGPoint(x: self.onPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
            self.offImageView.center = CGPoint(x: self.offPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
            
            
            self.onImageView.alpha = self.isOn ? 1.0 : 0.0
            self.offImageView.alpha = self.isOn ? 0.0 : 1.0
            
        }
    }
}

//Mark: Labels frame
extension CustomSwitch {
    
    fileprivate func setupLabels() {

        guard self.areLabelsShown else {
            self.labelOn.alpha = 0
            self.labelOff.alpha = 0
            return
            
        }
        
        self.labelOn.alpha = 1
        self.labelOff.alpha = 1
        
        let labelWidth = self.bounds.width / 2 - self.padding * 2
        self.labelOff.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOn.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOff.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.labelOn.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        if self.isOn {
            self.labelOff.textColor = Colors.customSwitchBlackColor
            self.labelOn.textColor = Colors.customSwitchWhiteColor
        } else {
            self.labelOff.textColor = Colors.customSwitchWhiteColor
            self.labelOn.textColor = Colors.customSwitchBlackColor
        }
        
        self.labelOn.sizeToFit()
        self.labelOn.textAlignment = .center
        self.labelOff.textAlignment = .center

        self.insertSubview(self.labelOn, aboveSubview: self.thumbView)
        self.insertSubview(self.labelOff, aboveSubview: self.thumbView)
    }
    
    public func myCustomSwitchSetup() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.onTintColor = Colors.customSwitchLightGrayColor
        self.offTintColor = Colors.customSwitchLightGrayColor
        self.cornerRadius = 0.1
        self.thumbCornerRadius = 0.1
        self.thumbTintColor = Colors.customSwitchWhiteColor
        self.animationDuration = 0.75
        self.areLabelsShown = true
        self.thumbSize = CGSize(width: 40, height: 30)
        self.padding = 0
        self.thumbTintColor = Colors.customSwitchBlueColor
        self.thumbShadowOffset = CGSize(width: 0, height: 0)
        self.thumbShaddowRadius = 0
        self.thumbShaddowOppacity = 0
    }
    
    public func setupLabelColor() {
        if self.isOn {
            self.labelOff.textColor = Colors.customSwitchBlackColor
            self.labelOn.textColor = Colors.customSwitchWhiteColor
        } else {
            self.labelOff.textColor = Colors.customSwitchWhiteColor
            self.labelOn.textColor = Colors.customSwitchBlackColor
        }
    }
    
}

//Mark: Animating on/off images
extension CustomSwitch {
    
    fileprivate func setOnOffImageFrame() {
        guard onImage != nil && offImage != nil else {
            return
        }
        
        self.onImageView.center.x = self.isOn ? self.onPoint.x + self.thumbView.frame.size.width / 2 : self.frame.width
        self.offImageView.center.x = !self.isOn ? self.offPoint.x + self.thumbView.frame.size.width / 2 : 0
        self.onImageView.alpha = self.isOn ? 1.0 : 0.0
        self.offImageView.alpha = self.isOn ? 0.0 : 1.0
        
    }
}
