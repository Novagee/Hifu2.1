//
//  YXViewController.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/11/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//
#import "SVProgressHUD.h"

#import "YXCalendarViewController.h"
#import "YXCalendarMonthView.h"
#import "YXCalendarDestinationCell.h"
#import "YXDestinationSearchView.h"
#import "YXCalendarFlightInfoCell.h"
#import "YXCalendarSelectRange.h"

//Apis
#import "ItineraryServerApi.h"
#import "CityServerApi.h"
#import "ServerModel.h"
#import "EasyData.h"

//Objects
#import "ItineraryObject.h"
#import "CityObject.h"
#import "WeatherObject.h"



@interface YXCalendarViewController ()
{
    YXDestinationSearchView *searchView;
    BOOL isEditing;
    NSMutableArray *itinerariesArray, *weathersArray;
    NSArray *citiesArray;
}

@end

@implementation YXCalendarViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendarView.delegate = self;
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    [HFUIHelpers removeBottomBorderFromNavBar:self.navigationController.navigationBar];

    [self.tableView registerNib:[YXCalendarDestinationCell cellNib] forCellReuseIdentifier:[YXCalendarDestinationCell reuseIdentifier]];
    [self.tableView registerNib:[YXCalendarFlightInfoCell cellNib] forCellReuseIdentifier:[YXCalendarFlightInfoCell reuseIdentifier]];
    isEditing = YES;
    [self loadCities];
    [self loadUserItinerary];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [EasyData setData:@"日程" forKey:@"currentView"];
    
//    NSDictionary * leftAtrb =   @{NSForegroundColorAttributeName  :   [UIColor whiteColor],
//
//                                  NSFontAttributeName             :   HeitiSC_Medium(14) };
//    
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes :   leftAtrb
//                                                         forState :   UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Methods
- (void)setupViewBasedOnIsEditingWithAnimation:(BOOL)animate
{
    if (isEditing) {
        self.editButton.title = @"完成";
        self.calendarView.hidden = NO;
        self.hintLabel.hidden= NO;
        if (animate) {
            self.calendarView.alpha = 0.0;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveEaseInOut animations:^{
                self.calendarView.alpha = 1.0;
                self.tableView.frame = CGRectMake(0, self.calendarView.frame.size.height + 10, HF_DEVICE_WIDTH, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.calendarView.frame.size.height - 10);
            } completion:^(BOOL finished) {
            }];
        }
        else
        {
            self.tableView.frame = CGRectMake(0, self.calendarView.frame.size.height + 10, HF_DEVICE_WIDTH, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.calendarView.frame.size.height - 10);
        }
    }
    else
    {
        self.editButton.title = @"编辑";
        self.hintLabel.hidden= YES;
        
        if (animate) {
            [UIView animateWithDuration:animate ? 0.3 : 0.0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveEaseInOut animations:^{
                self.calendarView.alpha = 0.0;
                self.tableView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
            } completion:^(BOOL finished) {
                self.calendarView.hidden = YES;
            }];
        }
        else
        {
            self.calendarView.hidden = YES;
            self.tableView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        }
    }
}

#pragma mark - API Load Methods
- (void)loadCities
{
    citiesArray = [CityServerApi getCities];
}

- (void)loadUserItinerary
{
    self.calendarView.hidden = YES;
    self.hintLabel.hidden = YES;
    itinerariesArray = [NSMutableArray new];
    
    [SVProgressHUD show];
    [ItineraryServerApi getItineraryForUser:[ServerModel sharedManager].userInfo.itemId
                                      success:^(id itineraries) {
                                          if ([itineraries isKindOfClass:[NSDictionary class]] && [itineraries objectForKey:@"destinations"] && ![[itineraries objectForKey:@"destinations"] isKindOfClass:[NSNull class]])
                                          {
                                              for (NSDictionary *dict in [itineraries objectForKey:@"destinations"]) {
                                                  ItineraryObject *itinerary = [[ItineraryObject alloc] initWithDictionary:dict];
                                                  
                                                  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                                                  NSDateComponents *startDateComponents = [gregorian components:(NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:itinerary.startDate];
                                                  NSDateComponents *endDateComponents = [gregorian components:(NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:itinerary.endDate];
                                                  
                                                  YXCalendarSelectRange *range = [[YXCalendarSelectRange alloc] initWithStartDay:startDateComponents endDay:endDateComponents andIndex:[self.calendarView.rangesArray count]];
                                                  range.rangeColor = [HFGeneralHelpers getItineraryColorForIndex:[self.calendarView.rangesArray count]];
                                                  [self.calendarView.rangesArray addObject:range];
                                                  range.itinerary = itinerary;
                                                  range.city = [citiesArray objectAtIndex:[itinerary.cityId integerValue] - 1];
                                              }
                                              [self.calendarView sortAllRanages];
                                          }
                                          isEditing = [self.calendarView.rangesArray count] > 0 ? NO : YES;
                                          [self setupViewBasedOnIsEditingWithAnimation:NO];
                                          [self.tableView reloadData];
                                          [self loadWeather];
                                          [SVProgressHUD dismiss];
                                      } failure:^(NSError *error) {
                                          NSLog(@"Loading Itinerary Error");
                                          isEditing = YES;
                                          [self setupViewBasedOnIsEditingWithAnimation:NO];
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void)loadWeather
{
    NSMutableArray *tempZipcodeArray = [NSMutableArray new];
    if (!weathersArray) {
        weathersArray = [NSMutableArray new];
    }
    else
        [weathersArray removeAllObjects];
    
    for (YXCalendarSelectRange *range in self.calendarView.sortedArray) {
        [tempZipcodeArray addObject:range.city.zipcode];
    }
    
    [ItineraryServerApi getWeathersForZipcodes:tempZipcodeArray success:^(id weathers) {
        for (NSInteger i = 0; i < [[weathers objectForKey:@"weathers"] count]; i++)
        {
            NSDictionary *dict = [[weathers objectForKey:@"weathers"] objectAtIndex:i];
            WeatherObject *w = [[WeatherObject alloc]initWithDictionary:dict];
            [weathersArray addObject:w];
            YXCalendarDestinationCell *cell = (YXCalendarDestinationCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(isEditing ? i: i+1) inSection:0]];
            if (cell) {
                [self updateWeatherForCell:cell andWeather:w];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get weather for zipcodes error");
    }];
}

- (void)updateWeatherForCell:(YXCalendarDestinationCell *)cell andWeather:(WeatherObject *)w
{
    cell.weather = w;
    cell.weaterhInfoView.hidden = NO;
    [cell.weatherActivityLoader stopAnimating];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:0];
    cell.tempNumberLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:[w.tempCelsius floatValue]]];
    cell.tempIconImageView.image = w.weatherType ? [UIImage imageNamed:w.weatherType] : [UIImage imageNamed:@"weather"];
 
}

#pragma mark - YXCalendarViewDelegate
- (void)calendarView:(YXCalendarView *)calendarView andMonthView:(YXCalendarMonthView *)monthView didChangeToVisibleMonth:(NSDateComponents *)month
{
    self.calendarView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, monthView.frame.size.height + HFCalendarHeaderViewHeight);
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.tableView.frame = CGRectMake(0, self.calendarView.frame.size.height + 10,
                                                           HF_DEVICE_WIDTH,
                                                           self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.calendarView.frame.size.height - 10);
                     } completion:^(BOOL finished) {
        
                     }];
}

- (void)calendarView:(YXCalendarView *)calendarView didSelectRange:(YXCalendarSelectRange *)range
{
    
}

- (void)calendarView:(YXCalendarView *)calendarView didSelectRange:(YXCalendarSelectRange *)range withLastTouchedViewOrigin:(CGPoint)touchedViewOrigin
{
    if (!searchView) {
        //230 search table view width, 80 is 320 - 230 - 10, 10 is the space to the right
        float searchTableViewX = touchedViewOrigin.x + 230 > HF_DEVICE_WIDTH ? 80 : touchedViewOrigin.x;
        //10 is the space to the bottom, 303 is the search table view height
        float searchTableViewY =  (touchedViewOrigin.y + 303 + 64 >= HF_DEVICE_HEIGHT) ? (HF_DEVICE_HEIGHT - 303 - 10) : touchedViewOrigin.y + 64;
        searchView = [[YXDestinationSearchView alloc] initWithWrapperViewOrigin:CGPointMake(searchTableViewX,searchTableViewY)];
        searchView.range = range;
        searchView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, HF_DEVICE_HEIGHT);
        searchView.alpha = 0.0;
        searchView.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissSearchViewByDelete) name:HFCalDismissSearchView
                                                   object:nil];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:searchView];
    
   [UIView animateWithDuration:0.2 delay:0
                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
             animations:^{
                 if ((touchedViewOrigin.y + 303 >= self.view.frame.size.height)) {
                     float offsetX = touchedViewOrigin.y - HFCalendarHeaderViewHeight - (self.view.frame.size.height - 303 - 10);
                     if (self.calendarView.isMonthViewTwoShow) {
                         self.calendarView.monthViewTwo.frame = CGRectMake(0, -offsetX,
                                                                           HF_DEVICE_WIDTH, self.calendarView.monthViewTwo.frame.size.height);
                     }
                     else
                     {
                         self.calendarView.monthViewOne.frame = CGRectMake(0, -offsetX,
                                                                           HF_DEVICE_WIDTH, self.calendarView.monthViewOne.frame.size.height);
                     }

                 }
                 searchView.alpha = 1.0;
             } completion:^(BOOL finished) {
                 if (searchView.range.itinerary.cityId) {
                     [searchView scrollToIndex:[searchView.range.itinerary.cityId intValue]];
                 }
             }];
}

#pragma mark - Actions
- (void)dismissDestinationSearchView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        searchView.alpha = 0.0;
        if (self.calendarView.isMonthViewTwoShow) {
            self.calendarView.monthViewTwo.frame = CGRectMake(0, HFCalendarHeaderViewHeight,
                                                              HF_DEVICE_WIDTH, self.calendarView.monthViewTwo.frame.size.height);
        }
        else
        {
            self.calendarView.monthViewOne.frame = CGRectMake(0, HFCalendarHeaderViewHeight,
                                                              HF_DEVICE_WIDTH, self.calendarView.monthViewOne.frame.size.height);
        }
    } completion:^(BOOL finished) {
        searchView.delegate = nil;
        [searchView removeFromSuperview];
        searchView = nil;
    }];
}

- (void)dismissSearchViewByDelete
{
    [self.tableView reloadData];
    [self dismissDestinationSearchView];
}

- (IBAction)editButtonClicked:(id)sender
{
    isEditing = !isEditing;
    //call the dismiss current select, just in case if user select a range and click "done" before select a destination
    [searchView dismissCurrentSelect];
    NSMutableArray *tempItineraryArray = [NSMutableArray new];
    NSMutableArray *tempZipcodeArray = [NSMutableArray new];

    for (YXCalendarSelectRange *range in self.calendarView.sortedArray) {
        [tempItineraryArray addObject:range.itinerary];
        [tempZipcodeArray addObject:range.city.zipcode];
    }
    if (!isEditing) {
        [ItineraryServerApi saveItineraries:tempItineraryArray withUserId:[ServerModel sharedManager].userInfo.itemId success:^(NSArray *idArray) {
            for (int i = 0; i < [idArray count]; i++) {
                ((YXCalendarSelectRange *)[self.calendarView.sortedArray objectAtIndex:i]).itinerary.itemId = [[idArray objectAtIndex:i] stringValue];
            }
        } failure:^(NSError *error) {
            NSLog(@"Save itineraires failed");
        }];
    }
    
    [self.tableView reloadData];
    [self loadWeather];
    [self.calendarView updateAllDaySelectionStateForRanges];
    [self setupViewBasedOnIsEditingWithAnimation:YES];
}

#pragma mark - YXDestinationSearchView
- (void)destinationSearchView:(YXDestinationSearchView *)searchView didSelectItineray:(ItineraryObject *)selectedItinerary forRange:(YXCalendarSelectRange *)range
{
    [self.tableView reloadData];
    [self dismissDestinationSearchView];
}

- (void)destinationSearchViewDismiss
{
    [self dismissDestinationSearchView];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isEditing ? [self.calendarView.rangesArray count] : [self.calendarView.rangesArray count] + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YXCalendarDestinationCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditing &&
        (indexPath.row == 0 || indexPath.row == [self.calendarView.rangesArray count] + 1))
    {
        YXCalendarFlightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXCalendarFlightInfoCell reuseIdentifier]];
        if (indexPath.row == 0) {
            cell.flightImageView.transform = CGAffineTransformMakeRotation(M_PI);
            cell.tripTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击此处添加出发信息" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.533 alpha:1.000]}];
            cell.tripTextField.tag = 1;
            cell.tripTextField.delegate = self;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"goTripInfo"]) {
                cell.tripTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"goTripInfo"];
            }
        }
        else
        {
            cell.flightImageView.transform = CGAffineTransformIdentity;
            cell.tripTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击此处添加回程信息" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.533 alpha:1.000]}];
            cell.tripTextField.tag = 2;
            cell.tripTextField.delegate = self;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"backTripInfo"]) {
                cell.tripTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"backTripInfo"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (!isEditing &&
             (indexPath.row == 0 || indexPath.row == [self.calendarView.rangesArray count] + 2))
    {
        //weather provider cell
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 65)];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weatherProvider"]];
        imageView.center = cell.center;
        [cell addSubview:imageView];
        return cell;
    }
    
    YXCalendarDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXCalendarDestinationCell reuseIdentifier]];
    int indexFactor = isEditing ? 0 : 1;
    cell.range = [self.calendarView.sortedArray objectAtIndex:indexPath.row - indexFactor];
    cell.destinationNameLabel.text = cell.range.city.nameCN;
    cell.colorLabel.backgroundColor = cell.range.rangeColor;
    cell.startDateLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)cell.range.startDay.month, (long)cell.range.startDay.day];
    cell.endDateLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)cell.range.endDay.month, (long)cell.range.endDay.day];
    cell.taxNumberLabel.text = [NSString stringWithFormat:@"%.2f %%", [cell.range.city.tax floatValue]];
    cell.detailInfoView.hidden = isEditing ? YES : NO;
    cell.colorLabelRightSide.hidden = YES;
    cell.cellRightBarLabel.hidden = NO;
    if ([weathersArray count] > indexPath.row - indexFactor) {
        cell.weather = [weathersArray objectAtIndex:indexPath.row - indexFactor];
    }
    
    if (cell.weather) {
        [self updateWeatherForCell:cell andWeather:cell.weather];
    }
    else
    {
        cell.weaterhInfoView.hidden = YES;
        [cell.weatherActivityLoader startAnimating];
    }
    
    cell.cellTopBarLabel.backgroundColor = [UIColor colorWithWhite:0.741 alpha:1.000];
    if ([[NSDate date] compare:cell.range.endDate] == NSOrderedAscending &&
        [[NSDate date] compare:cell.range.startDate] == NSOrderedDescending)
    {
        cell.colorLabelRightSide.hidden = cell.cellBottomBarLabel.hidden = NO;
        cell.colorLabelRightSide.backgroundColor = cell.cellTopBarLabel.backgroundColor =  cell.cellBottomBarLabel.backgroundColor = cell.range.rangeColor;
        cell.cellRightBarLabel.hidden = YES;
    }
    cell.cellBottomBarLabel.hidden = indexPath.row - indexFactor != [self.calendarView.sortedArray count] - 1 ? YES : NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //when it's not editing, the 0 row and last row are flight info cells
    if (!isEditing && (indexPath.row == 0 || indexPath.row == [self.calendarView.rangesArray count] + 1 || indexPath.row == [self.calendarView.rangesArray count] + 2)) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *itineraryId = @"";
        if (!isEditing) {
            itineraryId = ((YXCalendarSelectRange *)[self.calendarView.sortedArray objectAtIndex:indexPath.row - 1]).itinerary.itemId;
        }
        else
        {
            itineraryId = ((YXCalendarSelectRange *)[self.calendarView.sortedArray objectAtIndex:indexPath.row]).itinerary.itemId;
        }
        
        if (itineraryId && ![itineraryId isEqualToString:@""]) {
            [ItineraryServerApi deleteItineraryForId:itineraryId success:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDeleteRange object:[self.calendarView.sortedArray objectAtIndex:isEditing ? indexPath.row :indexPath.row - 1]];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } failure:^(NSError *error) {
                NSLog(@"delete itinerary failed");
            }];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:HFCalDeleteRange object:[self.calendarView.sortedArray objectAtIndex:isEditing ? indexPath.row :indexPath.row - 1]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - UITableView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //if the return trip text field start editing, we need to check if it's coverd by keyboard.
    //if so move it up above keyboard, keyboard height is 288px in retina.
    //There is an extra white bar if they are typing in chinese, so we give another extra 30px for it.
    if (!isEditing && textField.tag == 2) {
        self.tableView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, HF_DEVICE_HEIGHT - 318);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!isEditing && textField.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"backTripInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (!isEditing && textField.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"goTripInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (self.tableView.frame.size.height == (HF_DEVICE_HEIGHT - 318)) {
        self.tableView.frame = CGRectMake(0, 0, HF_DEVICE_WIDTH, HF_DEVICE_HEIGHT);
    }
}

@end
