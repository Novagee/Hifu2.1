//
//  YXShoppingListViewController.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/19/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <NSMutableArray+SWUtilityButtons.h>

#import "YXShoppingListViewController.h"
#import "YXShoppingListItemCell.h"
#import "YXShoppingListTagView.h"
#import "YXShoppingAddNewViewController.h"

//Apis
#import "ShoppingListServerApi.h"
#import "ServerModel.h"

//Objects
#import "ShoppingItemObject.h"

@interface YXShoppingListViewController ()
{
    NSMutableArray *unboughtItemsArray, *boughtItemsArray, *unboughtItemTagViewsArray, *boughtItemTagViewsArray;
    float tagNextX, tagCurrentY, tagNextY;
}


@end

@implementation YXShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [HFUIHelpers setupStyleFor:self.navigationController.navigationBar and:self.navigationItem];
    [HFUIHelpers removeBottomBorderFromNavBar:self.navigationController.navigationBar];

    unboughtItemTagViewsArray = [NSMutableArray new];
    boughtItemTagViewsArray = [NSMutableArray new];
    
    [self.tableView registerNib:[YXShoppingListItemCell cellNib] forCellReuseIdentifier:[YXShoppingListItemCell reuseIdentifier]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItemAdded:) name:HFFinishAddingNewShoppingItem object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemEdited:) name:HFFinishEditingShoppingItem object:nil];
    
    //change the font of segemented control
    [self.slSegmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:15]} forState:UIControlStateNormal];
    
    //load both bought and unbought item
    [self loadShoppingItems:@(-1)];
    
    UITapGestureRecognizer *tapOnNoItemImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnNoItemImageToAdd)];
    [self.noItemImageView addGestureRecognizer:tapOnNoItemImage];
    self.noItemImageView.userInteractionEnabled = YES;
}

- (void)tapOnNoItemImageToAdd
{
    [self performSegueWithIdentifier:@"pushToAddNewItemViewController" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.topItem.title = @"购物清单";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushToAddNewItemViewController"]) {
        YXShoppingAddNewViewController *vc = [segue destinationViewController];
        if ([sender isKindOfClass:[ShoppingItemObject class]]) {
            vc.shoppingItem = sender;
        }
    }
}

#pragma mark - Action Methods
- (IBAction)slSgementedControlValueChanged:(id)sender
{
    if (self.slSegmentedControl.selectedSegmentIndex == 0) {
        if (unboughtItemsArray)
        {
            if ([unboughtItemsArray count] > 0) {
                self.noItemImageView.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            else
            {
                self.noItemImageView.hidden = NO;
                self.tableView.hidden = YES;
            }
        }
        else
            [self loadShoppingItems:@(0)];
    }
    else
    {
        if (boughtItemsArray)
        {
            self.noItemImageView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        else
            [self loadShoppingItems:@(1)];
    }
}

#pragma mark - Api Methods
- (void)loadShoppingItems:(NSNumber *)isBought
{
    [SVProgressHUD show];
    [ShoppingListServerApi getShoppingListForUser:[ServerModel sharedManager].userInfo.itemId
                                           isBought:isBought
                                            success:^(id shoppingItems)
    {
        boughtItemsArray = [NSMutableArray new];
        unboughtItemsArray = [NSMutableArray new];

        for (NSDictionary *dict in [shoppingItems objectForKey:@"shoppingItems"]) {
            ShoppingItemObject *item = [[ShoppingItemObject alloc] initWithDictionary:dict];
            if ([item.bought boolValue]) {
                [boughtItemsArray addObject:item];
            }
            else
            {
                [unboughtItemsArray addObject:item];
            }
        }
        if (([boughtItemsArray count] > 0 && self.slSegmentedControl.selectedSegmentIndex == 1) || ([unboughtItemsArray count] > 0 && self.slSegmentedControl.selectedSegmentIndex == 0)) {
            self.noItemImageView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        else
        {
            self.noItemImageView.hidden = NO;
            self.tableView.hidden = YES;
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"get shopping list error");
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Notification Methods
- (void)newItemAdded:(NSNotification *)notification
{
    ShoppingItemObject *item = [notification object];
    [unboughtItemsArray addObject:item];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.slSegmentedControl.selectedSegmentIndex == 0) {
        self.noItemImageView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)itemEdited:(NSNotification *)notification
{
    ShoppingItemObject *item = [notification object];
    if([item.bought boolValue])
    {
        if ([boughtItemsArray containsObject:item]) {
            [boughtItemsArray replaceObjectAtIndex:[boughtItemsArray indexOfObject:item] withObject:item];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.slSegmentedControl.selectedSegmentIndex == 1) {
                [self.tableView reloadData];
            }
        }
    }
    else
    {
        if ([unboughtItemsArray containsObject:item]) {
            [unboughtItemsArray replaceObjectAtIndex:[unboughtItemsArray indexOfObject:item] withObject:item];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.slSegmentedControl.selectedSegmentIndex == 0) {
                [self.tableView reloadData];
            }
        }
    }
   
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.slSegmentedControl.selectedSegmentIndex == 0) {
        return [unboughtItemsArray count];
    }
    else
    {
        return [boughtItemsArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.slSegmentedControl.selectedSegmentIndex == 0) {
        UIView *view = [self constructViewForItem:[unboughtItemsArray objectAtIndex:indexPath.row]];
        ;
        if ([unboughtItemTagViewsArray count] > indexPath.row)
            [unboughtItemTagViewsArray replaceObjectAtIndex:indexPath.row withObject:view];
        else
            [unboughtItemTagViewsArray addObject:view];
        return view.frame.size.height + 10;
    }
    else
    {
        UIView *view = [self constructViewForItem:[boughtItemsArray objectAtIndex:indexPath.row]];
        ;
        if ([boughtItemTagViewsArray count] > indexPath.row)
            [boughtItemTagViewsArray replaceObjectAtIndex:indexPath.row withObject:view];
        else
            [boughtItemTagViewsArray addObject:view];
        return view.frame.size.height + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXShoppingListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[YXShoppingListItemCell reuseIdentifier]];

    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    UIView *tagWrapperView;
    ShoppingItemObject *item;
    
    if (self.slSegmentedControl.selectedSegmentIndex == 0) {
        tagWrapperView = [unboughtItemTagViewsArray objectAtIndex:indexPath.row];
        item = [unboughtItemsArray objectAtIndex:indexPath.row];
    }
    else
    {
        tagWrapperView = [boughtItemTagViewsArray objectAtIndex:indexPath.row];
        item = [boughtItemsArray objectAtIndex:indexPath.row];
    }
    
    [cell.innerView addSubview:tagWrapperView];
    cell.shoppingItem = item;
    
    if (item.picture) {
        cell.itemImageView.image = item.picture;
    }
    else if (item.pictureUrl && ![item.pictureUrl isEqualToString:@""])
    {
        [cell.itemImageView setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      if (image && !error) {
                                          cell.itemImageView.image = image;
                                          cell.shoppingItem.picture = image;
                                      }
                                      
                                  }];
    }
    else
    {
        cell.itemImageView.image = [UIImage imageNamed:@"defaultItemImage"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.slSegmentedControl.selectedSegmentIndex == 0)
        [self performSegueWithIdentifier:@"pushToAddNewItemViewController" sender:[unboughtItemsArray objectAtIndex:indexPath.row]];
    else
        [self performSegueWithIdentifier:@"pushToAddNewItemViewController" sender:[boughtItemsArray objectAtIndex:indexPath.row]];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    ShoppingItemObject *item = self.slSegmentedControl.selectedSegmentIndex == 0 ? [unboughtItemsArray objectAtIndex:cellIndexPath.row] : [boughtItemsArray objectAtIndex:cellIndexPath.row];

    switch (index) {
        case 0:
        {
            //Bought/Rebought button was pressed
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:item.itemId forKey:@"itemId"];
            [params setObject:self.slSegmentedControl.selectedSegmentIndex == 0 ? @(1) : @(0) forKey:@"bought"];
    
            [ShoppingListServerApi updateShoppingListItemWithParams:[params mutableCopy] didImageChange:NO andImage:nil success:^{
                NSLog(@"Set Item to bought success");
                if (self.slSegmentedControl.selectedSegmentIndex == 0) {
                    [unboughtItemsArray removeObject:item];
                    [boughtItemsArray addObject:item];
                }
                else
                {
                    [boughtItemsArray removeObject:item];
                    [unboughtItemsArray addObject:item];
                }
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                NSLog(@"Set Item to bought failed");
            }];
        }
            break;
        case 1:
        {
            // Delete button was pressed
            [ShoppingListServerApi deleteShoppingListItemWithId:item.itemId success:^{
                if (self.slSegmentedControl.selectedSegmentIndex == 0) {
                    [unboughtItemsArray removeObjectAtIndex:cellIndexPath.row];
                }
                else
                {
                    [boughtItemsArray removeObjectAtIndex:cellIndexPath.row];
                }
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                NSLog(@"%@", [error userInfo]);
            }];

            break;
        }
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:self.slSegmentedControl.selectedSegmentIndex == 0 ? @"已买" : @"再买"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    return rightUtilityButtons;
}

#pragma mark - Helper Methods

- (UIView *)constructViewForItem:(ShoppingItemObject *)item
{
    UIView *tagsWrapperView = [[UIView alloc]initWithFrame:CGRectMake(80, 3, 210, 100)];
    tagsWrapperView.userInteractionEnabled = NO;
    tagNextX = 0.0f;
    tagCurrentY = tagNextY = 0.0f;
    if (item.brand && ![item.brand isEqualToString:@""] ) {
        YXShoppingListTagView *tagView = [self generateTagViewForType:YXShoppingListBrandTag forItemString:item.brand];
        [tagsWrapperView addSubview:tagView];
    }
    
    if (item.color && ![item.color isEqualToString:@""]) {
        YXShoppingListTagView *tagView = [self generateTagViewForType:YXShoppingListColorTag forItemString:item.color];
        [tagsWrapperView addSubview:tagView];
    }
    
    if (item.quantity) {
        YXShoppingListTagView *tagView = [self generateTagViewForType:YXShoppingListQuantityTag forItemString:[item.quantity stringValue]];
        [tagsWrapperView addSubview:tagView];
    }
    
    if (item.forWhom && ![item.forWhom isEqualToString:@""]) {
        YXShoppingListTagView *tagView = [self generateTagViewForType:YXShoppingListUserNameTag forItemString:item.forWhom];
        [tagsWrapperView addSubview:tagView];
    }
    
    if (item.priceInUSD && [item.priceInUSD floatValue] != 0.0) {
        YXShoppingListTagView *tagView = [self generateTagViewForPriceInRMB:[item.priceInUSD floatValue] *6.23 andUSD:[item.priceInUSD floatValue]];
        [tagsWrapperView addSubview:tagView];
    }

    if (item.notes && ![item.notes isEqualToString:@""]) {
        float noteLabelY = tagNextY < 77 ? 77 : tagNextY;
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, noteLabelY, 214, 20)];
        noteLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        noteLabel.text = item.notes;
        noteLabel.textColor = [UIColor grayColor];
        [tagsWrapperView addSubview:noteLabel];
        tagNextY = tagNextY + 20;
    }
    
    float tagWrapperViewHeight = tagNextY <= 100 ? 100 : tagNextY;
    tagsWrapperView.frame = CGRectMake(tagsWrapperView.frame.origin.x, tagsWrapperView.frame.origin.y, tagsWrapperView.frame.size.width, tagWrapperViewHeight);
    
    return tagsWrapperView;
}

- (YXShoppingListTagView *)generateTagViewForType:(YXShoppingListTagViewType)type forItemString:(NSString *)itemString
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];

    YXShoppingListTagView *view = [[YXShoppingListTagView alloc] initWithTagType:type withTextViewKeyobardType:UIKeyboardTypeDefault];
    
    float width = [HFGeneralHelpers getTextWidth:itemString andFont:font andHeight:HFShoppingListTagViewDefaultTextViewHeight] + 20;
    if (width + HFShoppingListTagViewHorizontalSpace > 210 - tagNextX)
    {
        if (width + HFShoppingListTagViewHorizontalSpace > 210) {
            float height = [HFGeneralHelpers getTextHeight:itemString andFont:font andWidth:210 - HFShoppingListTagViewHorizontalSpace] + 20;
            view.frame = CGRectMake(0, tagNextY, 210, height + HFShoppingListTagViewVerticalSpace);
        }
        else
        {
            view.frame = CGRectMake(0, tagNextY, width + HFShoppingListTagViewHorizontalSpace, HFShoppingListTagViewDefaultHeight);
        }
   }
    else
    {
        view.frame = CGRectMake(tagNextX, tagCurrentY, width + HFShoppingListTagViewHorizontalSpace, HFShoppingListTagViewDefaultHeight);
    }
    
    tagCurrentY = view.frame.origin.y;
    tagNextX = view.frame.origin.x + view.frame.size.width + 5;
    tagNextY = view.frame.origin.y + view.frame.size.height + 5;
    
    view.textView.text = itemString;
    [view.textView setEditable:NO];
    [view.textView setScrollEnabled:NO];
    return view;
}

- (YXShoppingListTagView *)generateTagViewForPriceInRMB:(float)rmb andUSD:(float)usd
{
    YXShoppingListTagView *view = [[YXShoppingListTagView alloc] initWithTagType:YXShoppingListPriceTag withTextViewKeyobardType:UIKeyboardTypeDefault];
    view.textView.hidden = YES;
    view.priceWrapperView.hidden = NO;
    view.frame = CGRectMake(0, tagNextY, 210, HFShoppingListTagViewDefaultHeight);
    tagCurrentY = view.frame.origin.y;
    tagNextX = view.frame.origin.x + view.frame.size.width + 5;
    tagNextY = view.frame.origin.y + view.frame.size.height + 5;
    
    view.rmbTextField.text = [NSString stringWithFormat:@"%.0f", rmb];
    view.usdTextField.text = [NSString stringWithFormat:@"%.0f", usd];;
    [view.rmbTextField setEnabled:NO];
    [view.usdTextField setEnabled:NO];
    return view;
}

@end
