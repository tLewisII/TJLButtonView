//
//  TJLButtonView.m
//  Tap Buttons
//
//  Created by Terry Lewis II on 8/19/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//
#define center(a) CGPointMake(CGRectGetMinX(a) + 125, CGRectGetMinY(a) + 125)

#import <QuartzCore/QuartzCore.h>
#import "TJLButtonView.h"

@interface TJLButtonView () {
    TJLButtonTappedBlock buttonTappedBlock;
    TJLButtonTappedBlock closeBlock;
}
@property(strong, nonatomic) UIView *buttonContainer;
@property(strong, nonatomic) UIView *parentView;
@property(strong, nonatomic) NSMutableArray *buttonArray;
@property(strong, nonatomic) NSArray *bezierPathArray;
@property(strong, nonatomic) UIButton *closeButton;
@property(nonatomic) NSUInteger animationIndex;
@end

@implementation TJLButtonView
- (instancetype)initWithView:(UIView *)view images:(NSArray *)images buttonTitles:(NSArray *)titles {
    return [self initWithView:view delegate:nil images:images buttonTitles:titles];
}

- (instancetype)initWithView:(UIView *)view delegate:(id <TJLButtonViewDelegate>)delegate images:(NSArray *)images buttonTitles:(NSArray *)titles {
    self = [super init];
    if(self) {
        if(delegate) self.delegate = delegate;
        [self setupBezierPaths];
        self.animationIndex = 0;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.parentView = view;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.3];

        self.buttonContainer = [[UIView alloc]init];
        self.buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:self.buttonContainer];
        [self.buttonContainer addConstraints:@[
                [NSLayoutConstraint
                        constraintWithItem:self.buttonContainer
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:250],

                [NSLayoutConstraint
                        constraintWithItem:self.buttonContainer
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0 constant:250]
        ]];

        [self addConstraints:@[
                [NSLayoutConstraint
                        constraintWithItem:self.buttonContainer
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0],

                [NSLayoutConstraint
                        constraintWithItem:self.buttonContainer
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0]
        ]];

        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.closeButton setImage:[UIImage imageNamed:@"Redx"] forState:UIControlStateNormal];
        [self.closeButton setTitle:@"Close" forState:UIControlStateDisabled];
        [self.closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:self.closeButton];
        [self.buttonContainer addConstraints:@[
                [NSLayoutConstraint
                        constraintWithItem:self.closeButton
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.buttonContainer
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0],

                [NSLayoutConstraint
                        constraintWithItem:self.closeButton
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.buttonContainer
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0]
        ]];

        self.buttonArray = [NSMutableArray new];
        for(NSUInteger i = 0; i < images.count; i++) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.translatesAutoresizingMaskIntoConstraints = NO;
            [b setImage:images[i] forState:UIControlStateNormal];
            [b setTitle:titles[i] forState:UIControlStateDisabled];
            [b addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonContainer addSubview:b];
            [self.buttonArray addObject:b];
        }

        for(NSUInteger i = 0; i < images.count; i++) {
            CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframe.duration = .5;
            UIBezierPath *path = self.bezierPathArray[i];
            UIButton *b = self.buttonArray[i];
            b.center = CGPathGetCurrentPoint(path.CGPath);
            keyframe.path = path.CGPath;
            keyframe.delegate = self;
            keyframe.fillMode = kCAFillModeForwards;
            keyframe.removedOnCompletion = YES;
            [b.layer addAnimation:keyframe forKey:@"btnAnimation"];
        }
    }
    return self;
}

- (void)setButtonTappedBlock:(TJLButtonTappedBlock)block {
    buttonTappedBlock = [block copy];
}

- (void)setCloseButtonTappedBlock:(TJLButtonTappedBlock)block {
    closeBlock = [block copy];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(self.animationIndex == (self.buttonArray.count * 2) - 1) [self removeFromSuperview];
    self.animationIndex++;
}

- (void)show {
    [self.parentView addSubview:self];
    [self.parentView addConstraints:@[
            [NSLayoutConstraint
                    constraintWithItem:self
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                                toItem:self.parentView
                             attribute:NSLayoutAttributeCenterX
                            multiplier:1.0
                              constant:0],

            [NSLayoutConstraint
                    constraintWithItem:self
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                                toItem:self.parentView
                             attribute:NSLayoutAttributeCenterY
                            multiplier:1.0
                              constant:0],

            [NSLayoutConstraint
                    constraintWithItem:self
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                                toItem:self.parentView
                             attribute:NSLayoutAttributeWidth
                            multiplier:1.0
                              constant:0],

            [NSLayoutConstraint
                    constraintWithItem:self
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                                toItem:self.parentView
                             attribute:NSLayoutAttributeHeight
                            multiplier:1.0
                              constant:0]
    ]];
}

- (void)buttonTapped:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateDisabled];
    if([self.delegate respondsToSelector:@selector(buttonView:titleForTappedButton:)]) [self.delegate buttonView:self titleForTappedButton:title];
    if(buttonTappedBlock) buttonTappedBlock(self, title);
}

- (void)closeView:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateDisabled];
    if([self.delegate respondsToSelector:@selector(buttonView:closeButtonTapped:)]) [self.delegate buttonView:self closeButtonTapped:title];
    if(closeBlock) closeBlock(self, title);

    [self setupCloseBezierPaths];
    for(NSUInteger i = 0; i < self.buttonArray.count; i++) {
        CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyframe.duration = .5;
        UIBezierPath *path = self.bezierPathArray[i];
        UIButton *b = self.buttonArray[i];
        b.center = CGPathGetCurrentPoint(path.CGPath);
        keyframe.path = path.CGPath;
        keyframe.delegate = self;
        keyframe.fillMode = kCAFillModeForwards;
        keyframe.removedOnCompletion = YES;
        [b.layer addAnimation:keyframe forKey:@"btnAnimation"];
    }
}

- (void)setupBezierPaths {
    CGRect frame = self.buttonContainer.bounds;
    //// topRight Drawing
    UIBezierPath *topRightPath = [UIBezierPath bezierPath];
    [topRightPath moveToPoint:center(frame)];
    [topRightPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 182, CGRectGetMinY(frame) + 100.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 134) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 159.25, CGRectGetMinY(frame) + 123.5)];
    [topRightPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 236.5, CGRectGetMinY(frame) + 79.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 204.75, CGRectGetMinY(frame) + 77.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 236.5, CGRectGetMinY(frame) + 79.5)];

    //// bottomRight Drawing
    UIBezierPath *bottomRightPath = [UIBezierPath bezierPath];
    [bottomRightPath moveToPoint:center(frame)];
    [bottomRightPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 181, CGRectGetMinY(frame) + 168) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 123.5, CGRectGetMinY(frame) + 134.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 158.25, CGRectGetMinY(frame) + 145)];
    [bottomRightPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 211, CGRectGetMinY(frame) + 222) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 203.75, CGRectGetMinY(frame) + 191) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 211, CGRectGetMinY(frame) + 222)];

    //// bottomLeft Drawing
    UIBezierPath *bottomLeftPath = [UIBezierPath bezierPath];
    [bottomLeftPath moveToPoint:center(frame)];
    [bottomLeftPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 66.5, CGRectGetMinY(frame) + 167) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 124, CGRectGetMinY(frame) + 133.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 89.25, CGRectGetMinY(frame) + 144)];
    [bottomLeftPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 36.5, CGRectGetMinY(frame) + 221) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 43.75, CGRectGetMinY(frame) + 190) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 36.5, CGRectGetMinY(frame) + 221)];

    //// topCenter Drawing
    UIBezierPath *topCenterPath = [UIBezierPath bezierPath];
    [topCenterPath moveToPoint:center(frame)];
    [topCenterPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 123.5, CGRectGetMinY(frame) + 78) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 123.5, CGRectGetMinY(frame) + 133) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 100.75, CGRectGetMinY(frame) + 101)];
    [topCenterPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 123.5, CGRectGetMinY(frame) + 10.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 146.25, CGRectGetMinY(frame) + 55) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 123.5, CGRectGetMinY(frame) + 10.5)];

    //// topLeft Drawing
    UIBezierPath *topLeftPath = [UIBezierPath bezierPath];
    [topLeftPath moveToPoint:center(frame)];
    [topLeftPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 67, CGRectGetMinY(frame) + 100.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 134) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 89.75, CGRectGetMinY(frame) + 123.5)];
    [topLeftPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 12.5, CGRectGetMinY(frame) + 79.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 44.25, CGRectGetMinY(frame) + 77.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 12.5, CGRectGetMinY(frame) + 79.5)];

    self.bezierPathArray = @[topLeftPath, topRightPath, topCenterPath, bottomLeftPath, bottomRightPath];
}

- (void)setupCloseBezierPaths {
    CGRect frame = self.buttonContainer.bounds;

    //// topRight Drawing
    UIBezierPath *topRightPath = [UIBezierPath bezierPath];
    [topRightPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 237.5, CGRectGetMinY(frame) + 78.46)];
    [topRightPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 180, CGRectGetMinY(frame) + 111.96) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 237.5, CGRectGetMinY(frame) + 78.46) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 202.75, CGRectGetMinY(frame) + 88.96)];
    [topRightPath addCurveToPoint:center(frame) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 157.25, CGRectGetMinY(frame) + 134.96) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 125.5, CGRectGetMinY(frame) + 132.96)];

    //// bottomRight Drawing
    UIBezierPath *bottomRightPath = [UIBezierPath bezierPath];
    [bottomRightPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 212, CGRectGetMinY(frame) + 221)];
    [bottomRightPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 154.5, CGRectGetMinY(frame) + 187.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 212, CGRectGetMinY(frame) + 221) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 177.25, CGRectGetMinY(frame) + 210.5)];
    [bottomRightPath addCurveToPoint:center(frame) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 131.75, CGRectGetMinY(frame) + 164.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 133.5)];

    //// bottomLeft Drawing
    UIBezierPath *bottomLeftPath = [UIBezierPath bezierPath];
    [bottomLeftPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 37.5, CGRectGetMinY(frame) + 220)];
    [bottomLeftPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 95, CGRectGetMinY(frame) + 186.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 37.5, CGRectGetMinY(frame) + 220) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 72.25, CGRectGetMinY(frame) + 209.5)];
    [bottomLeftPath addCurveToPoint:center(frame) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 117.75, CGRectGetMinY(frame) + 163.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 125, CGRectGetMinY(frame) + 132.5)];

    //// topCenter Drawing
    UIBezierPath *topCenterPath = [UIBezierPath bezierPath];
    [topCenterPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 9.5)];
    [topCenterPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 64.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 9.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 101.75, CGRectGetMinY(frame) + 41.5)];
    [topCenterPath addCurveToPoint:center(frame) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 147.25, CGRectGetMinY(frame) + 87.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 124.5, CGRectGetMinY(frame) + 132)];

    //// topLeft Drawing
    UIBezierPath *topLeftPath = [UIBezierPath bezierPath];
    [topLeftPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 13.5, CGRectGetMinY(frame) + 78.46)];
    [topLeftPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 71, CGRectGetMinY(frame) + 111.96) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 13.5, CGRectGetMinY(frame) + 78.46) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 48.25, CGRectGetMinY(frame) + 88.96)];
    [topLeftPath addCurveToPoint:center(frame) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 93.75, CGRectGetMinY(frame) + 134.96) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 125.5, CGRectGetMinY(frame) + 132.96)];

    self.bezierPathArray = @[topLeftPath, topRightPath, topCenterPath, bottomLeftPath, bottomRightPath];
}
@end
