//
//  TJLButtonView.h
//  Tap Buttons
//
//  Created by Terry Lewis II on 8/19/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJLButtonView;

@protocol TJLButtonViewDelegate <NSObject>
@required
/**
 *       Sends the title of the button that was tapped.
 *@param buttonView The instance of the class that is currently active
 *@param title The title of the tapped button.
 */
- (void)buttonView:(TJLButtonView *)buttonView titleForTappedButton:(NSString *)title;

@optional
/**
 *       Sends the close button when it is tapped
 *@param buttonView The instance of the class that is currently active
 *@param closeButton The close button
 */
- (void)buttonView:(TJLButtonView *)buttonView closeButtonTapped:(NSString *)title;
@end

typedef void (^TJLButtonTappedBlock)(TJLButtonView *buttonView, NSString *title);

@interface TJLButtonView : UIView
/**
 *       A View that has a variable number of buttons that animate out from the center and animate back in when closed.
 *@param view The view to show in. Will be show like UIAlertView, IE will use `view`s bounds as its frame.
 *@param delegate The delegate object that conforms to the TJLButtonViewDelegate protocol.
 *@param images An array of UIImages that will serve as the image for each button.
 *@param buttonTitles The title for each button. Note that the title is invisible, as it is set for UIControlStateDisabled,
 *       but is used for the delegate to indicate which button was tapped. Button titles should follow the images give in the
 *       `images` array.
 *@return An instance of the class.
 */
- (instancetype)initWithView:(UIView *)view delegate:(id <TJLButtonViewDelegate>)delegate images:(NSArray *)images buttonTitles:(NSArray *)titles;

/**
 *       A View that has a variable number of buttons that animate out from the center and animate back in when closed.
 *@param view The view to show in. Will be show like UIAlertView, IE will use `view`s bounds as its frame.
 *@param images An array of UIImages that will serve as the image for each button.
 *@param buttonTitles The title for each button. Note that the title is invisible, as it is set for UIControlStateDisabled,
 *       but is used for the delegate to indicate which button was tapped. Button titles should follow the images give in the
 *       `images` array.
 *@return An instance of the class.
 */
- (instancetype)initWithView:(UIView *)view images:(NSArray *)images buttonTitles:(NSArray *)titles;

/**
 *  Sets the image for the "Close" button in the center of the view. Required.
 *@param image The image used for the "Close" button.
 */
-(void)setCloseButtonImage:(UIImage *)image;

/**
 * A block that is called each time a button is tapped.
 *@param block The block that will be called when a button is tapped.
 */
- (void)setButtonTappedBlock:(TJLButtonTappedBlock)block;

/**
 * A block that is called when the close button is tapped
 *@param block The block that will be called when a button is tapped.
 */
- (void)setCloseButtonTappedBlock:(TJLButtonTappedBlock)block;

///Shows the button view in the view that it was initialized with.
- (void)show;

///The delegate
@property(strong, nonatomic) id <TJLButtonViewDelegate> delegate;
@end

