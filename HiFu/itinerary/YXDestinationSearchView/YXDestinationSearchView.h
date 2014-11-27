//
//  YXDestinationSearchView.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/15/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXCalendarSelectRange, ItineraryObject;

@protocol YXDestinationSearchViewDelegate;
@interface YXDestinationSearchView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
 
@property (nonatomic, weak) IBOutlet UIView *searchWrapperView;
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;
@property (nonatomic, weak) id<YXDestinationSearchViewDelegate>delegate;
@property (nonatomic, strong) YXCalendarSelectRange *range;

- (IBAction)deleteButtonClicked:(id)sender;
- (id)initWithWrapperViewOrigin:(CGPoint)origin;
- (void)dismissCurrentSelect;
- (void)scrollToIndex:(int)index;

@end

@protocol YXDestinationSearchViewDelegate <NSObject>

@optional
- (void)destinationSearchView:(YXDestinationSearchView *)searchView
            didSelectItineray:(ItineraryObject *)selectedItinerary
                     forRange:(YXCalendarSelectRange *)range;

- (void)destinationSearchView:(YXDestinationSearchView *)searchView
               didDeleteRange:(YXCalendarSelectRange *)deletedRnage;

- (void)destinationSearchViewDismiss;
@end

