# Pokemon TCG iOS Interview Tasks

## 🐛 Bug Reports

### Bug A: Search Loading Never Stops
When searching fails, the loading spinner continues indefinitely.

### Bug B: App Crashes on Some Cards  
Navigate to certain card detail views - the app will crash.

### Bug C: Card Changes After Visiting Screen
Navigate to any card detail view and go back - the card information changes unexpectedly.

### Bug D: Too Many API Calls
During search, the app makes excessive API requests causing performance issues.

### Bug E: Card Images Keep Changing
Card images randomly change or disappear when scrolling through the list or navigating between screens.

## ⚡ Quick Fixes

**Enhancement 1: Persist Search Results**
- Search results disappear when tapping elsewhere or scrolling
- Keep search results visible and preserve user's search state for this session

**Enhancement 2: Empty State**
- Show proper empty state when no search results

**Enhancement 3: Navigation Title**
- Detail view should show Pokemon name in title

**Enhancement 4: Pagination Loading**
- Add "Load More" button or infinite scroll at bottom of list

**Enhancement 5: Loading Indicators**
- Better loading states during search

**Enhancement 6: Card Image Caching**
- Implement AsyncImage with proper loading states
- Add image caching for better performance

## 🎯 Implementation Tasks

**Feature 1: Sets List Screen** - Create a new screen that shows all Pokemon card sets

**Feature 2: Set Detail Screen** - Create detail screen for a specific Pokemon set showing cards in that set

**Feature 3: Favorites System** - Add ability to favorite/unfavorite Pokemon cards