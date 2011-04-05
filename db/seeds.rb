# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Checklist.delete_all
Checklist.create(:title=>'This New List',:list=>'This New List
1. List item 1
2. List item 2
3. List item 3
4. New asd asd asd assd asda
5. This is cool!
6. What is in a name!
7. This is so cool!
8. I am workingNew iasd;asjd ;akld
9. This is another test
10. This is the next item
11. And another item!
12. This is a new item! whooT
13. OK i\'m here with this item
14. This is a test item
emond@usc.edu')

Checklist.create(:title=>'SAGF: Weekly sanity check',:list=>'SAGF: Weekly sanity check
1. Confirm CRON is running
2. Perform search on member list and verify dataset returned is correct
3. Select 3 random members and verify correct general and CAP eligibility status based on recent event history
4. Check past 50 log entries in watchdog for any unusual activity
5. Confirm watchdog is being clipped
6. Run all available unit tests
7. RSVP for an event
8. Edit a node and confirm paste from Word retains formatting
9. Confirm MC newsletter options appear in member profile screen
10. Check about us page and verify Google map is displayed correctly
11. Verify member auto-complete is working correctly
12. Add a member to an event
13. Move a member from the seated list to the waitlist, and vice versa
14. Run check-in list report and verify data and totals are correct
15. Sync stage site with live site
16. Turn off email sending on staging site so that it only logs
17. Testing the new stuff
18. This is now
19. Frank and beans!
justin.emond@gmail.com, emond@usc.edu')