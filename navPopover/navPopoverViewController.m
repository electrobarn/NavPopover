//
//  navPopoverViewController.m
//  navPopover
//
//  Copyright (c) 2011, ElectroBarn Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the <organization> nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  Created by David Anderson on 5/12/11.
//

#import "navPopoverViewController.h"

#import "EBFirstViewController.h"
#import "EBSecondViewController.h"
#import "EBAlternateSecondViewController.h"

@implementation navPopoverViewController
@synthesize showPopoverButton;
@synthesize popoverController;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setShowPopoverButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)showNavPopover:(id)sender {
    
    // init first view controller
    EBFirstViewController *firstViewController = [[EBFirstViewController alloc] initWithArray:[NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil]];
    
    // stick it in a navigation controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    navigationController.delegate = self;
    
    // show the navigation controller in a popover
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popoverController = popover;
    popoverController.delegate = self;
    
    [popoverController presentPopoverFromRect:self.showPopoverButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];


}

#pragma mark - UINavigationControllerDelegate

// adjusts popover size during navigationController animation
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@"navigationController:willShowViewController:%@ view frame: %0.1f, %0.1f, %0.1f, %0.1f", [viewController class], viewController.view.frame.origin.x, viewController.view.frame.origin.y, viewController.view.frame.size.width, viewController.view.frame.size.height);
    // for some reason the viewController.view.frame is the same as window.frame (768 x 1024) though if we set the popover content size including correction it appears to go back to normal
    
    if ([viewController isMemberOfClass:[EBFirstViewController class]]) {
        EBFirstViewController *firstViewController = (EBFirstViewController *)viewController;
        NSLog(@"navigationController:willShowViewController:%@ tableView frame: %0.1f, %0.1f, %0.1f, %0.1f", [firstViewController class], firstViewController.tableView.frame.origin.x, firstViewController.tableView.frame.origin.y, firstViewController.tableView.frame.size.width, firstViewController.tableView.frame.size.height);
        
        NSLog(@"navigationController:willShowViewController:%@ setPopoverContentSize: %0.1f, %0.1f (excluding correction)", [firstViewController class], firstViewController.popoverContentSize.width, firstViewController.popoverContentSize.height);

        // due to something unexplainable, the popoverContentSize
        // must be set to 37 points taller than the actual content
        // is this to account for the header of the popover because its
        // in a navigation controller?
        // navigationController.navigationBar.frame.size is 44 points, not 37
        CGSize size = firstViewController.popoverContentSize;
        size.height += 37.0f; //correction factor for popoverContentSize
                
        [self.popoverController setPopoverContentSize:size animated:YES];
    } else if ([viewController isMemberOfClass:[EBSecondViewController class]]) {
        EBSecondViewController *secondViewController = (EBSecondViewController *)viewController;
        
        NSLog(@"navigationController:willShowViewController:%@ setPopoverContentSize: %0.1f, %0.1f (excluding correction)", [secondViewController class], secondViewController.popoverContentSize.width, secondViewController.popoverContentSize.height);
        
        CGSize size = secondViewController.popoverContentSize;
        size.height += 37.0f; //correction factor for popoverContentSize
        
        [self.popoverController setPopoverContentSize:size animated:YES];
    } else if ([viewController isMemberOfClass:[EBAlternateSecondViewController class]]) {
        EBAlternateSecondViewController *alternateSecondViewController = (EBAlternateSecondViewController *)viewController;
        
        NSLog(@"navigationController:willShowViewController:%@ setPopoverContentSize: %0.1f, %0.1f (excluding correction)", [alternateSecondViewController class], alternateSecondViewController.popoverContentSize.width, alternateSecondViewController.popoverContentSize.height);
        
        CGSize size = alternateSecondViewController.popoverContentSize;
        size.height += 37.0f; //correction factor for popoverContentSize
        
        [self.popoverController setPopoverContentSize:size animated:YES];
    }

    CGSize popoverSize = self.popoverController.popoverContentSize;
    NSLog(@"navigationController:willShowViewController:%@ popoverContentSize: %0.1f, %0.1f (including correction)", [viewController class], popoverSize.width, popoverSize.height);

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@"navigationController:didShowViewController:%@ view frame: %0.1f, %0.1f, %0.1f, %0.1f", [viewController class], viewController.view.frame.origin.x, viewController.view.frame.origin.y, viewController.view.frame.size.width, viewController.view.frame.size.height);

}
@end
