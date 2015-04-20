//
//  DetailViewController.h
//  StarCatcher
//
//  Created by Rishabh Sharma on 6/7/14.
//  Copyright (c) 2014 Gracenote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
