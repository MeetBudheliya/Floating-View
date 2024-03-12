//
//  ViewController.swift
//  FloatingView
//
//  Created by Meet Budheliya on 12/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    let view_header = UIView()
    let button_window = UIButton()
    let view_floating = UIView()
    let button_close = UIButton()
    let button_min_max = UIButton()
    let button_side = UIButton()
    let button_resize = UIButton()
    let lbl_description = UILabel()
    let img_display = UIImageView()
    let stack_center = UIStackView()
    let stack_component = UIStackView()
    var pan_gesture = UIPanGestureRecognizer()
    
    var is_popup = false
    var is_full_screen = false{
        didSet{
            
            button_min_max.isHidden = false
            button_close.isHidden = false
            
            if is_full_screen{
                view_floating.frame = view.safeAreaLayoutGuide.layoutFrame
                view_floating.removeShadow()
                button_side.isHidden = true
                button_resize.isHidden = true
            }else{
                view_floating.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                view_floating.center = view.center
                view_floating.dropShadow()
                button_side.isHidden = false
                button_resize.isHidden = false
            }
        }
    }
    
    var orientation_changed = false
    var is_side_screen = false{
        didSet{
            let screen = view.safeAreaLayoutGuide.layoutFrame
            
            button_side.isHidden = false
            if is_side_screen{
                button_min_max.isHidden = true
                button_close.isHidden = true
                button_resize.isHidden = true
                view_floating.removeShadow()
                
                if self.isLandscapeMode(){
                    view_floating.frame = CGRect(x: screen.width, y: screen.minY, width: (screen.width/2), height: screen.height)
                    UIView.animate(withDuration: 0.5) { [self] in
                        view_floating.frame = CGRect(x: (screen.width/2), y: screen.minY, width: (screen.width/2), height: screen.height)
                    }
                }else{
                    view_floating.frame = CGRect(x: -screen.width, y: screen.minY, width: screen.width, height: screen.height)
                    UIView.animate(withDuration: 0.5) { [self] in
                        view_floating.frame = CGRect(x: screen.minX, y: screen.minY, width: screen.width, height: screen.height)
                    }
                }
                
            }else{
                is_popup = false
                
                if self.isLandscapeMode(){
                    view_floating.frame = CGRect(x: (screen.width/2), y: screen.minY, width: (screen.width/2), height: screen.height)
                    UIView.animate(withDuration: 0.5) { [self] in
                        view_floating.frame = CGRect(x: screen.width, y: screen.minY, width: (screen.width/2), height: screen.height)
                    }
                }else{
                    view_floating.frame = CGRect(x: screen.minX, y: screen.minY, width: screen.width, height: screen.height)
                    UIView.animate(withDuration: 0.5) { [self] in
                        view_floating.frame = CGRect(x: -screen.width, y: screen.minY, width: screen.width, height: screen.height)
                    }
                }
            }
        }
    }
    
    var initial_touch: CGPoint = CGPoint.zero

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard orientation_changed else { return }
        orientation_changed = false
        
        if is_popup{
            if is_full_screen{
                view_floating.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
                button_side.isHidden = true
                button_resize.isHidden = true
            }else{
                view_floating.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                view_floating.center = view.center
                button_side.isHidden = false
                button_resize.isHidden = false
            }
        }
        
        button_window.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        button_window.center = view.center
        
    }
 
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(#function)
        orientation_changed = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        initial_touch = touch.location(in: view)
      }

    
    // MARK: - Methods
    private func setupViews() {
        // Setup button
        view_floating.backgroundColor = .white
        view_floating.conrnerRadius()
        is_full_screen = false
        
        // set button property
        button_window.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        button_window.center = view.center
        button_window.setTitle("Open Window", for: .normal)
        button_window.setTitleColor(.black, for: .normal)
        button_window.backgroundColor = .lightGray
        button_window.conrnerRadius()
        button_window.border()
        view.addSubview(button_window)
        
        button_window.addTarget(self, action: #selector(BTNOpenWindowAction), for: .touchUpInside)
        
    }
    
        
    
    //MARK: - Actions
    @objc func BTNOpenWindowAction(){
        is_popup = true
        is_full_screen = false
       
        view.addSubview(view_floating)
        
        view_floating.dropShadow()
        
        // add gesture to view
        pan_gesture = UIPanGestureRecognizer(target: self, action: #selector(handler))
        view_header.addGestureRecognizer(pan_gesture)
        
        // Add and configure components
        view_floating.addSubview(view_header)
        view_floating.addSubview(stack_center)
        view_header.addSubview(stack_component)
        view_header.addSubview(button_close)
        view_header.addSubview(button_min_max)
        view_header.addSubview(button_side)
        view_floating.addSubview(button_resize)
        view_floating.addSubview(lbl_description)
        view_floating.addSubview(img_display)
        
        
        button_close.setTitle("", for: .normal)
        button_close.setImage(UIImage(named: "ic_close"), for: .normal)
        
        button_min_max.setTitle("", for: .normal)
        button_min_max.setImage(UIImage(named: "ic_maximize"), for: .normal)
        
        button_side.setTitle("", for: .normal)
        button_side.setImage(UIImage(named: "ic_side"), for: .normal)
        
        button_resize.setTitle("", for: .normal)
        button_resize.setImage(UIImage(named: "ic_resize"), for: .normal)
        button_resize.isMultipleTouchEnabled = true
        
        lbl_description.text = "\tBursting with imagery, motion, interaction and distraction though it is, today’s World Wide Web is still primarily a conduit for textual information. In HTML5, the focus on writing and authorship is more pronounced than ever."
        lbl_description.numberOfLines = 0
        
        img_display.image = UIImage(named: "img_trees")
        img_display.conrnerRadius()
        
        // Add constraints
        view_header.translatesAutoresizingMaskIntoConstraints = false
        button_close.translatesAutoresizingMaskIntoConstraints = false
        button_min_max.translatesAutoresizingMaskIntoConstraints = false
        button_side.translatesAutoresizingMaskIntoConstraints = false
        button_resize.translatesAutoresizingMaskIntoConstraints = false
        lbl_description.translatesAutoresizingMaskIntoConstraints = false
        img_display.translatesAutoresizingMaskIntoConstraints = false
        stack_center.translatesAutoresizingMaskIntoConstraints = false
        stack_component.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            view_header.topAnchor.constraint(equalTo: view_floating.topAnchor),
            view_header.leadingAnchor.constraint(equalTo: view_floating.leadingAnchor),
            view_header.trailingAnchor.constraint(equalTo: view_floating.trailingAnchor),
            view_header.heightAnchor.constraint(equalToConstant: 25),
            
            button_close.topAnchor.constraint(equalTo: view_header.topAnchor, constant: 10),
            button_close.trailingAnchor.constraint(equalTo: view_header.trailingAnchor, constant: -10),
            button_close.heightAnchor.constraint(equalToConstant: 25),
            button_close.widthAnchor.constraint(equalToConstant: 25),
            
            button_min_max.topAnchor.constraint(equalTo: view_header.topAnchor, constant: 10),
            button_min_max.leadingAnchor.constraint(equalTo: view_header.leadingAnchor, constant: 10),
            button_min_max.heightAnchor.constraint(equalToConstant: 25),
            button_min_max.widthAnchor.constraint(equalToConstant: 25),
//
            button_side.topAnchor.constraint(equalTo: view_header.topAnchor, constant: 10),
            button_side.leadingAnchor.constraint(equalTo: button_min_max.trailingAnchor, constant: 10),
            button_side.heightAnchor.constraint(equalToConstant: 25),
            button_side.widthAnchor.constraint(equalToConstant: 25),
            
            button_resize.bottomAnchor.constraint(equalTo: view_floating.bottomAnchor, constant: -10),
            button_resize.trailingAnchor.constraint(equalTo: view_floating.trailingAnchor, constant: -10),
            button_resize.heightAnchor.constraint(equalToConstant: 25),
            button_resize.widthAnchor.constraint(equalToConstant: 25),
            
//            lbl_description.centerXAnchor.constraint(equalTo: view_floating.centerXAnchor),
//            lbl_description.centerYAnchor.constraint(equalTo: view_floating.centerYAnchor),
//
//            img_display.centerXAnchor.constraint(equalTo: view_floating.centerXAnchor),
//            img_display.centerYAnchor.constraint(equalTo: view_floating.centerYAnchor),
            img_display.widthAnchor.constraint(equalToConstant: 100), // Set your image width
            img_display.heightAnchor.constraint(equalTo: view_floating.heightAnchor, multiplier: 0.5), // Set your image height
            
//            stack_center.centerXAnchor.constraint(equalTo: view_floating.centerXAnchor),
//            stack_center.centerYAnchor.constraint(equalTo: view_floating.centerYAnchor),
            
            stack_component.topAnchor.constraint(equalTo: view_header.topAnchor, constant: 10),
            stack_component.leadingAnchor.constraint(equalTo: view_header.leadingAnchor, constant: 10),
            stack_component.heightAnchor.constraint(equalToConstant: 25),
//            stack_component.widthAnchor.constraint(equalToConstant: 55),
            
            stack_center.topAnchor.constraint(equalTo: button_close.bottomAnchor, constant: 10),
            stack_center.bottomAnchor.constraint(equalTo: button_resize.topAnchor, constant: -10),
            stack_center.leadingAnchor.constraint(equalTo: view_floating.leadingAnchor, constant: 10),
            stack_center.trailingAnchor.constraint(equalTo: view_floating.trailingAnchor, constant: -10)
            
           
        ])
        
        stack_component.addArrangedSubview(button_min_max)
        stack_component.addArrangedSubview(button_side)
        stack_component.axis = .horizontal
        stack_component.spacing = 5
        
        stack_center.addArrangedSubview(img_display)
        stack_center.addArrangedSubview(lbl_description)
        stack_center.axis = .vertical
        stack_center.spacing = 5
        
        // buttons actions
        button_close.addTarget(self, action: #selector(BTNCloseAction), for: .touchUpInside)
        button_min_max.addTarget(self, action: #selector(BTNMinimizeMaximizeAction), for: .touchUpInside)
        button_side.addTarget(self, action: #selector(BTNSideAction), for: .touchUpInside)
        button_resize.addTarget(self, action: #selector(BTNResizeDragged), for: .touchDragInside)
    }
    
    @objc func handler(gesture: UIPanGestureRecognizer){

        let location = gesture.location(in: self.view)
        print(location)
//
//        if button_resize.frame.contains(location) {
//            // If the touch is within the bounds of the resize button, allow the pan gesture
//            
//            return
//        }

        
        let bounds = view.bounds

        // Calculate the minimum and maximum x and y to keep the view within the screen bounds
        let minX = bounds.minX + view_header.bounds.width / 2
        let maxX = bounds.maxX - view_header.bounds.width / 2
        let minY = bounds.minY - view_floating.bounds.height
        let maxY = bounds.maxY - view_floating.bounds.height

        // Ensure the floating view stays within the boundaries
        var new_center = location
        new_center.x = min(maxX, max(minX, location.x))
        new_center.y = min(maxY, max(minY, location.y))

        view_floating.frame = CGRect(x: new_center.x - (view_header.bounds.width / 2), y: new_center.y, width: view_floating.bounds.width, height: view_floating.bounds.height)
    }
    
    @objc func BTNCloseAction(){
        is_popup = false
        view_floating.removeFromSuperview()
    }
    
    @objc func BTNMinimizeMaximizeAction(){
        is_full_screen.toggle()
    }
    
    @objc func BTNSideAction(){
        is_side_screen.toggle()
    }
    
    @objc func BTNResizeDragged(_ sender: UIButton, event: UIEvent) {
        guard let touch = event.touches(for: sender)?.first else { return }
        
        let current_touch = touch.location(in: view)
        
        let delta_x = current_touch.x - initial_touch.x
        let delta_y = current_touch.y - initial_touch.y
        
        let new_width = view_floating.frame.width + delta_x
        let new_height = view_floating.frame.height + delta_y
        
        // Calculate the maximum height
        let screen_height = view.safeAreaLayoutGuide.layoutFrame.height
        let screen_width = view.safeAreaLayoutGuide.layoutFrame.width
        let max_height = screen_height - view_floating.frame.minY
        let max_width = screen_width - view_floating.frame.minX
        
        let min_height = min(max(300, new_height), max_height)
        let min_width = min(max(300, new_width), max_width)
        
        // Update view's frame with animation
        UIView.animate(withDuration: 0.2) {
            self.view_floating.frame = CGRect(x: self.view_floating.frame.minX,
                                              y: self.view_floating.frame.minY,
                                              width: min_width,
                                              height: min_height)
            
            // Apply drop shadow after resizing
            self.view_floating.dropShadow()
        }
        
        // Update initial touch for next
        initial_touch = current_touch
    }
}

