//
//  YXDestinationSearchView.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/15/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXDestinationSearchView.h"
#import "YXDestinationSearchResultCell.h"
#import "YXCalendarSelectRange.h"

//Apis
#import "CityServerApi.h"
#import "ItineraryServerApi.h"

//Objects
#import "ItineraryObject.h"
#import "CityObject.h"

#import "UserServerApi.h"
#import <Appsee/Appsee.h>

@implementation YXDestinationSearchView
{
    NSArray *citiesArray, *searchResultArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


//#pragma mark - parallel array fix (return keys/values of dictionary)
//-(NSArray*)destinationTestNameArray{
//    return [self.destinationData allKeys];
//}
//
//-(NSArray*)destinationTestStateArray{
//    return [self.destinationData allValues];
//}


#pragma mark -

- (id)initWithWrapperViewOrigin:(CGPoint)origin
{
    self = [[UINib nibWithNibName:@"YXDestinationSearchView" bundle:nil] instantiateWithOwner:nil options:NULL][0];
    if (self) {
        self.searchWrapperView.frame = CGRectMake(origin.x, origin.y, 230, 303);
        [HFUIHelpers roundCornerToHFDefaultRadius:self.searchWrapperView];
        [self.searchTableView registerNib:[YXDestinationSearchResultCell cellNib] forCellReuseIdentifier:[YXDestinationSearchResultCell reuseIdentifier]];
        
//        citiesArray = [CityServerApi getCities];
        [CityServerApi getServerCitiesSuccess:^(id data) {
            NSMutableArray *arr=[NSMutableArray new];
            if (data) {
                for (NSDictionary *dict in data) {
                    CityObject *city = [[CityObject alloc] initWithDictionary:dict];
                    [arr addObject:city];
                }
            }
            citiesArray = [NSArray arrayWithArray:arr];
            searchResultArray = citiesArray;
            [self.searchTableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Load citied fail.");
        }];
    }
    return self;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YXDestinationSearchResultCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXDestinationSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXDestinationSearchResultCell reuseIdentifier]];
    cell.city = (CityObject *)searchResultArray[indexPath.row];
    cell.destinationName = cell.city.nameCN;
    cell.destinationNameLabel.text = cell.city.nameCN;
    cell.destinationStateNameLabel.text = cell.city.stateCN;
    if (self.range.itinerary && [[self.range.itinerary.cityId stringValue] isEqualToString:cell.city.itemId]) {
        [cell highlightDestinationNameWithColor:self.range.rangeColor];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.range.itinerary) {
        self.range.itinerary.cityId = @([((CityObject *)searchResultArray[indexPath.row]).itemId intValue]);
        [Appsee addEvent:@"Calendar City Selected" withProperties:@{@"userId":[UserServerApi sharedInstance].currentUserId,@"cityId":self.range.itinerary.cityId}];
        self.range.itinerary.startDate = self.range.startDate;
        self.range.itinerary.endDate = self.range.endDate;
    }
    else
    {
        ItineraryObject *itinerary = [[ItineraryObject alloc]init];
        itinerary.cityId = @([((CityObject *)searchResultArray[indexPath.row]).itemId intValue]);
        itinerary.startDate = self.range.startDate;
        itinerary.endDate = self.range.endDate;
        self.range.itinerary = itinerary;
        self.range.city = searchResultArray[indexPath.row];
        [Appsee addEvent:@"Calendar City Selected" withProperties:@{@"userId":[UserServerApi sharedInstance].currentUserId,@"cityId":self.range.city.itemId}];
    }

    
    //call the did select destination delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(destinationSearchView:didSelectItineray:forRange:)]) {
        [self.delegate destinationSearchView:self
                           didSelectItineray:self.range.itinerary
                                    forRange:self.range];
    }
}

#pragma mark - UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.searchWrapperView.frame = CGRectMake(self.searchWrapperView.frame.origin.x,
                                                  HF_DEVICE_HEIGHT - HF_KEYBOARD_HEIGHT - self.searchWrapperView.frame.size.height + 20,
                                                  self.searchWrapperView.frame.size.width,
                                                  self.searchWrapperView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText scope:nil];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nameCN CONTAINS[cd] %@ OR nameUS CONTAINS[cd] %@ OR stateCN CONTAINS [cd] %@ OR stateUS CONTAINS [cd] %@ OR stateUSShort CONTAINS [cd] %@", searchText, searchText, searchText, searchText, searchText];
    searchResultArray = [citiesArray filteredArrayUsingPredicate:resultPredicate];
    if ([searchText isEqualToString:@""]) {
        //if the search string is empty, we go back to the entire list
        searchResultArray = citiesArray;
    }
    [self.searchTableView reloadData];
}

#pragma mark - Actions
- (IBAction)deleteButtonClicked:(id)sender
{
    if (self.range.itinerary && self.range.itinerary.itemId) {
        [ItineraryServerApi deleteItineraryForId:self.range.itinerary.itemId success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDeleteRange object:self.range];
            [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDismissSearchView object:nil];
        } failure:^(NSError *error) {
            NSLog(@"delete itinerary from search city view failed");
        }];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDeleteRange object:self.range];
        [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDismissSearchView object:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != self.searchWrapperView) {
        //if the range we selected is brand new, user dismiss the search view before select a destination, we should delete it
        if (!self.range.itinerary) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDeleteRange object:self.range];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDismissSearchView object:nil];
    }
}

- (void)dismissCurrentSelect
{
    if (!self.range.destinationName) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDeleteRange object:self.range];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDismissSearchView object:nil];
}

- (void)scrollToIndex:(int)index
{
    [self.searchTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
