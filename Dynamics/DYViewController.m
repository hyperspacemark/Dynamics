//
//  DYViewController.m
//  Dynamics
//
//  Created by Mark Adams on 9/21/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "DYViewController.h"

@interface DYViewController ()

@property (weak, nonatomic) IBOutlet UIView *box;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachmentBehavior;

@end

@implementation DYViewController

#pragma mark - Properties

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }

    return _animator;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCollisionBoundary];
    [self addElasticityBehavior];
    [self addInstantaneousPushBehavior];
    [self addGravityBehavior];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - API
#pragma mark Collision Behavior

- (void)addCollisionBoundary
{
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.box]];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(44.0f - CGRectGetHeight(self.view.bounds), 0.0f, 0.0f, 0.0f);
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:edgeInsets];
    [self.animator addBehavior:collisionBehavior];
}

#pragma mark Gravity Behavior

- (void)addGravityBehavior
{
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.box]];
    self.gravityBehavior.gravityDirection = CGVectorMake(0.0f, 4.0f);
    [self.animator addBehavior:self.gravityBehavior];
}

- (void)removeGravityBehavior
{
    [self.animator removeBehavior:self.gravityBehavior];
    self.gravityBehavior = nil;
}

#pragma mark Elasticity Behavior

- (void)addElasticityBehavior
{
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.box]];
    elasticityBehavior.elasticity = 0.33;
    [self.animator addBehavior:elasticityBehavior];
}

#pragma mark Impulse Push Behavior

- (void)addInstantaneousPushBehavior
{
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.box] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 0.0f;
    self.pushBehavior.angle = 0.0f;
    [self.animator addBehavior:self.pushBehavior];
}

- (void)activatePushBehaviorWithPushDirection:(CGVector)pushDirection
{
    self.pushBehavior.pushDirection = pushDirection;
    self.pushBehavior.active = YES;
}

- (IBAction)boxWasTapped:(UITapGestureRecognizer *)sender
{
    CGVector pushDirection = CGVectorMake(0, -125);
    [self activatePushBehaviorWithPushDirection:pushDirection];
}

#pragma mark Pan Attachment Behavior

- (void)addPanAttachmentBehaviorWithAnchorPoint:(CGPoint)anchorPoint
{
    self.panAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.box attachedToAnchor:anchorPoint];
    [self.animator addBehavior:self.panAttachmentBehavior];
}

- (void)updatePanAttachmentBehaviorWithAnchorPoint:(CGPoint)anchorPoint
{
    self.panAttachmentBehavior.anchorPoint = anchorPoint;
}

- (void)removePanAttachmentBehavior
{
    [self.animator removeBehavior:self.panAttachmentBehavior];
    self.panAttachmentBehavior = nil;
}

- (IBAction)boxDidPan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = [panGesture locationInView:self.view];
    location.x = CGRectGetMidX(self.view.bounds);

    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self addPanAttachmentBehaviorWithAnchorPoint:location];
        [self removeGravityBehavior];
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        [self updatePanAttachmentBehaviorWithAnchorPoint:location];
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self addGravityBehavior];
        [self removePanAttachmentBehavior];
        CGVector pushDirection = CGVectorMake(0.0f, [panGesture velocityInView:self.view].y / 10.0f);
        [self activatePushBehaviorWithPushDirection:pushDirection];
    }
}

@end
